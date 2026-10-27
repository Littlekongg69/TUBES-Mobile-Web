enum ModuleStatus { completed, inProgress, locked }

class ModuleModel {
  final String id;
  final int position;
  final String title;
  final String description;
  final int estimatedMinutes;
  final ModuleStatus status;
  final double progress; // 0.0 to 1.0
  final String? prerequisiteTitle;
  final List<LessonModel> lessons;

  const ModuleModel({
    required this.id,
    required this.position,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    required this.status,
    required this.progress,
    this.prerequisiteTitle,
    this.lessons = const [],
  });

  ModuleModel copyWith({
    String? id,
    int? position,
    String? title,
    String? description,
    int? estimatedMinutes,
    ModuleStatus? status,
    double? progress,
    String? prerequisiteTitle,
    List<LessonModel>? lessons,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      position: position ?? this.position,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      prerequisiteTitle: prerequisiteTitle ?? this.prerequisiteTitle,
      lessons: lessons ?? this.lessons,
    );
  }
}

class LessonModel {
  final String id;
  final String moduleId;
  final int position;
  final String title;
  final String content;
  final String codeExample;
  final int estimatedMinutes;
  final int xpReward;
  final bool isCompleted;

  const LessonModel({
    required this.id,
    required this.moduleId,
    required this.position,
    required this.title,
    required this.content,
    required this.codeExample,
    required this.estimatedMinutes,
    required this.xpReward,
    this.isCompleted = false,
  });
}

class LearningPathModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final int totalLessons;
  final int xpReward;
  final double progressPercent;
  final List<ModuleModel> modules;

  const LearningPathModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.totalLessons,
    required this.xpReward,
    required this.progressPercent,
    required this.modules,
  });
}
