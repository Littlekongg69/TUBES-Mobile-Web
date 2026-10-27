import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../shared/models/challenge_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/hearts_indicator.dart';
import '../../../shared/widgets/table_data_card.dart';
import '../../../shared/widgets/sql_block_chip.dart';
import '../../../shared/widgets/primary_action_button.dart';

class SqlGameScreen extends ConsumerStatefulWidget {
  const SqlGameScreen({super.key});

  @override
  ConsumerState<SqlGameScreen> createState() => _SqlGameScreenState();
}

class _SqlGameScreenState extends ConsumerState<SqlGameScreen> {
  int _hearts = 5;
  bool _soundEnabled = true;
  bool _isSolved = false;

  // The predefined SQL Challenge according to PRD Section 14 & 16
  late SqlChallengeModel _challenge;

  // Slot states: slot 0 to 4
  // Target: [ SELECT ] [ * ] [ FROM ] [ slot_table ] [ WHERE ] [ slot_condition ]
  SqlBlock? _slotTable;
  SqlBlock? _slotCondition;

  // Available blocks pool
  late List<SqlBlock> _availableBlocks;

  @override
  void initState() {
    super.initState();
    _initChallenge();
  }

  void _initChallenge() {
    _challenge = const SqlChallengeModel(
      id: 'chal_001',
      questName: 'SQL Cooking Quest',
      missionNumber: 1,
      title: 'Bahan Masakan Chef Mario',
      story:
          'Restoran Chef Mario kedatangan rombongan tamu besar! Bantu Chef Mario memeriksa bahan makanan di dapur yang memiliki stok lebih dari 10.',
      objective:
          'Pilih seluruh kolom dari tabel bahan_makanan yang memiliki stok > 10.',
      tableName: 'bahan_makanan',
      tableColumns: ['id', 'nama_bahan', 'kategori', 'stok', 'harga'],
      tableRows: [
        [1, 'Daging Sapi Wagyu', 'Daging', 14, 185000],
        [2, 'Keju Mozzarella', 'Dairy', 8, 45000],
        [3, 'Bawang Bombay', 'Bumbu', 25, 12000],
        [4, 'Minyak Zaitun', 'Minyak', 5, 95000],
        [5, 'Tomat Segar', 'Sayur', 32, 8000],
      ],
      targetSlots: [],
      initialAvailableBlocks: [
        SqlBlock(id: 'b1', label: 'bahan_makanan', type: BlockType.table),
        SqlBlock(id: 'b2', label: 'stok > 10', type: BlockType.condition),
        SqlBlock(id: 'b3', label: 'daftar_resep', type: BlockType.table), // Pengecoh
        SqlBlock(id: 'b4', label: 'harga < 50000', type: BlockType.condition), // Pengecoh
        SqlBlock(id: 'b5', label: 'stok < 5', type: BlockType.condition), // Pengecoh
        SqlBlock(id: 'b6', label: 'kategori', type: BlockType.column), // Pengecoh
      ],
      expectedQueryKeywords: ['SELECT', '*', 'FROM', 'bahan_makanan', 'WHERE', 'stok > 10'],
      xpReward: 40,
      maxAttempts: 5,
      hint: 'Gunakan tabel bahan_makanan dan filter kolom stok dengan operator > 10.',
    );

    _availableBlocks = List.from(_challenge.initialAvailableBlocks);
    _slotTable = null;
    _slotCondition = null;
    _hearts = 5;
    _isSolved = false;
  }

  void _onBlockTapped(SqlBlock block) {
    if (_slotTable == null) {
      setState(() {
        _slotTable = block;
        _availableBlocks.remove(block);
      });
    } else if (_slotCondition == null) {
      setState(() {
        _slotCondition = block;
        _availableBlocks.remove(block);
      });
    }
  }

  void _removeSlotTable() {
    if (_slotTable != null) {
      setState(() {
        _availableBlocks.add(_slotTable!);
        _slotTable = null;
      });
    }
  }

  void _removeSlotCondition() {
    if (_slotCondition != null) {
      setState(() {
        _availableBlocks.add(_slotCondition!);
        _slotCondition = null;
      });
    }
  }

  void _clearAllSlots() {
    setState(() {
      if (_slotTable != null) _availableBlocks.add(_slotTable!);
      if (_slotCondition != null) _availableBlocks.add(_slotCondition!);
      _slotTable = null;
      _slotCondition = null;
    });
  }

  void _showHintDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Row(
          children: [
            Text('💡 '),
            Text('Petunjuk Soal'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_challenge.hint),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Text(
                'Biaya petunjuk: -4 XP (10% XP dasar)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _submitQuery() {
    final isTableCorrect = _slotTable?.label == 'bahan_makanan';
    final isConditionCorrect = _slotCondition?.label == 'stok > 10';

    if (isTableCorrect && isConditionCorrect) {
      // Award XP to user state
      setState(() => _isSolved = true);
      ref.read(userProvider.notifier).addXp(_challenge.xpReward);
      ref.read(missionsProvider.notifier).incrementGameQueries();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          title: const Row(
            children: [
              Text('🎉 '),
              Text('Jawaban Benar!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Correct! Query kamu menghasilkan data yang sesuai pesanan Chef Mario.'),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Text(
                  'SELECT * FROM bahan_makanan WHERE stok > 10;',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4ADE80),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.stars_rounded, color: AppColors.xpReward, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '+${_challenge.xpReward} XP Diperoleh!',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.xpReward,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _initChallenge();
              },
              child: const Text('Main Lagi / Ulangi'),
            ),
          ],
        ),
      );
    } else {
      // Wrong query result
      setState(() {
        if (_hearts > 1) {
          _hearts--;
        } else {
          _hearts = 0;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _hearts > 0
                ? 'Query berhasil dijalankan, tetapi hasilnya belum sesuai. Sisa kesempatan: $_hearts'
                : 'Percobaan habis! Silakan pelajari petunjuk atau ulangi tantangan.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allSlotsFilled = _slotTable != null && _slotCondition != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                '${_challenge.questName} • Misi ${_challenge.missionNumber}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          HeartsIndicator(currentHearts: _hearts, maxHearts: 5),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              _soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            onPressed: () => setState(() => _soundEnabled = !_soundEnabled),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Kartu Misi & Cerita
              AppCard(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                border: Border.all(color: AppColors.primaryLight, width: 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('👨‍🍳 ', style: TextStyle(fontSize: 22)),
                        Text(
                          _challenge.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _challenge.story,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        border: Border.all(color: AppColors.primaryContainer),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flag_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Target: ${_challenge.objective}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Kartu Tabel Contoh
              TableDataCard(
                tableName: _challenge.tableName,
                columns: _challenge.tableColumns,
                rows: _challenge.tableRows,
              ),
              const SizedBox(height: 20),

              // 3. Susun Query (Block Assembly Area)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Susun Kueri SQL',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: (_slotTable != null || _slotCondition != null) ? _clearAllSlots : null,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Kosongkan', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151C24) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const SqlBlockChip(
                      block: SqlBlock(id: 's1', label: 'SELECT', type: BlockType.keyword),
                      isSlotBlock: true,
                    ),
                    const SqlBlockChip(
                      block: SqlBlock(id: 's2', label: '*', type: BlockType.keyword),
                      isSlotBlock: true,
                    ),
                    const SqlBlockChip(
                      block: SqlBlock(id: 's3', label: 'FROM', type: BlockType.keyword),
                      isSlotBlock: true,
                    ),
                    // Slot 1: Table
                    if (_slotTable != null)
                      SqlBlockChip(
                        block: _slotTable!,
                        isSlotBlock: true,
                        onTap: _removeSlotTable,
                      )
                    else
                      _buildEmptySlot('Pilih Tabel ?', isDark),
                    const SqlBlockChip(
                      block: SqlBlock(id: 's4', label: 'WHERE', type: BlockType.keyword),
                      isSlotBlock: true,
                    ),
                    // Slot 2: Condition
                    if (_slotCondition != null)
                      SqlBlockChip(
                        block: _slotCondition!,
                        isSlotBlock: true,
                        onTap: _removeSlotCondition,
                      )
                    else
                      _buildEmptySlot('Kondisi Filter ?', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Pilihan Blok SQL (Palette)
              Text(
                'Pilihan Blok SQL (Ketuk untuk memasukkan)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: _availableBlocks.map((block) {
                  return SqlBlockChip(
                    block: block,
                    onTap: () => _onBlockTapped(block),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // 5. Action Buttons (Jalankan Query & Petunjuk)
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: _isSolved ? 'Tantangan Selesai 🎉' : 'Jalankan Query',
                  xpReward: _challenge.xpReward,
                  onPressed: (allSlotsFilled && !_isSolved && _hearts > 0) ? _submitQuery : null,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton.icon(
                  onPressed: _showHintDialog,
                  icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                  label: const Text('Tampilkan Petunjuk Soal (-4 XP)'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.blockSlot,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}
