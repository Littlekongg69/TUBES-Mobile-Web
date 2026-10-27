enum BlockType { keyword, table, column, condition, clause }

class SqlBlock {
  final String id;
  final String label;
  final BlockType type;

  const SqlBlock({
    required this.id,
    required this.label,
    required this.type,
  });
}

class SqlChallengeModel {
  final String id;
  final String questName;
  final int missionNumber;
  final String title;
  final String story;
  final String objective;
  final String tableName;
  final List<String> tableColumns;
  final List<List<dynamic>> tableRows;
  final List<SqlBlock?> targetSlots;
  final List<SqlBlock> initialAvailableBlocks;
  final List<String> expectedQueryKeywords;
  final int xpReward;
  final int maxAttempts;
  final String hint;

  const SqlChallengeModel({
    required this.id,
    required this.questName,
    required this.missionNumber,
    required this.title,
    required this.story,
    required this.objective,
    required this.tableName,
    required this.tableColumns,
    required this.tableRows,
    required this.targetSlots,
    required this.initialAvailableBlocks,
    required this.expectedQueryKeywords,
    this.xpReward = 40,
    this.maxAttempts = 5,
    required this.hint,
  });
}
