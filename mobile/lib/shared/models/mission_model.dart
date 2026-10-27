class DailyMissionModel {
  final String id;
  final String title;
  final String description;
  final int progress;
  final int target;
  final int xpReward;
  final bool isCompleted;
  final bool isClaimed;

  const DailyMissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.xpReward,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  DailyMissionModel copyWith({
    String? id,
    String? title,
    String? description,
    int? progress,
    int? target,
    int? xpReward,
    bool? isCompleted,
    bool? isClaimed,
  }) {
    return DailyMissionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
}
