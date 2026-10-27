import 'package:flutter_test/flutter_test.dart';
import 'package:sqlquest/shared/models/challenge_model.dart';

void main() {
  group('SQL Challenge Block Mode Logic Tests', () {
    test('Correct blocks validation', () {
      const challenge = SqlChallengeModel(
        id: 'chal_001',
        questName: 'SQL Cooking Quest',
        missionNumber: 1,
        title: 'Bahan Masakan Chef Mario',
        story: 'Test story',
        objective: 'Pilih semua dari bahan_makanan WHERE stok > 10',
        tableName: 'bahan_makanan',
        tableColumns: ['id', 'nama_bahan', 'kategori', 'stok', 'harga'],
        tableRows: [],
        targetSlots: [],
        initialAvailableBlocks: [],
        expectedQueryKeywords: ['SELECT', '*', 'FROM', 'bahan_makanan', 'WHERE', 'stok > 10'],
        xpReward: 40,
        hint: 'Test hint',
      );

      final slotTable = const SqlBlock(id: 'b1', label: 'bahan_makanan', type: BlockType.table);
      final slotCondition = const SqlBlock(id: 'b2', label: 'stok > 10', type: BlockType.condition);

      final isTableCorrect = slotTable.label == challenge.tableName;
      final isConditionCorrect = slotCondition.label == 'stok > 10';

      expect(isTableCorrect, isTrue);
      expect(isConditionCorrect, isTrue);
      expect(challenge.xpReward, 40);
      expect(challenge.maxAttempts, 5);
    });

    test('Wrong distractors validation', () {
      final wrongTable = const SqlBlock(id: 'b3', label: 'daftar_resep', type: BlockType.table);
      final wrongCondition = const SqlBlock(id: 'b4', label: 'harga < 50000', type: BlockType.condition);

      expect(wrongTable.label == 'bahan_makanan', isFalse);
      expect(wrongCondition.label == 'stok > 10', isFalse);
    });
  });
}
