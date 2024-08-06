class Exercise {
  String? id;
  String? title;
  String? video;
  String? muscleId;
  int? level;
  bool? isHomeExercise;

  Exercise({
    this.id,
    this.title,
    this.video,
    this.muscleId,
    this.level,
    this.isHomeExercise,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'video': video,
      'muscleId': muscleId,
      'level': level,
      'isHomeExercise': isHomeExercise,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      title: map['title'] as String,
      video: map['video'] as String,
      muscleId: map['muscleId'] as String,
      level: map['level'] as int,
      isHomeExercise: map['home_exe'] as bool,
    );
  }

  @override
  String toString() {
    return 'Exercise(title: $title, video: $video, muscleId: $muscleId, level: $level, isHomeExercise: $isHomeExercise)';
  }
}
