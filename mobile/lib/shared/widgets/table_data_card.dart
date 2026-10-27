import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'app_card.dart';

class TableDataCard extends StatelessWidget {
  final String tableName;
  final List<String> columns;
  final List<List<dynamic>> rows;

  const TableDataCard({
    super.key,
    required this.tableName,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderCol = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.table_chart_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  tableName,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${rows.length} baris data',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 34,
              dataRowMinHeight: 32,
              dataRowMaxHeight: 36,
              columnSpacing: 20,
              horizontalMargin: 14,
              headingRowColor: WidgetStateProperty.all(headerBg),
              border: TableBorder(
                horizontalInside: BorderSide(color: borderCol, width: 0.5),
              ),
              columns: columns.map((col) {
                return DataColumn(
                  label: Text(
                    col,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
              rows: rows.map((row) {
                return DataRow(
                  cells: row.map((cell) {
                    final isNumber = cell is num;
                    final formattedText = isNumber
                        ? (cell is double && cell == cell.toInt()
                            ? cell.toInt().toString()
                            : cell.toString())
                        : cell.toString();

                    return DataCell(
                      Text(
                        formattedText,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
