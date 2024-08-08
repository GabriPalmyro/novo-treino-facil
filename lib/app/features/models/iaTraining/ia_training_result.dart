class IATrainingResult {
  String title;
  String description;
  List<ExerciseIA> exercises;

  IATrainingResult({
    required this.title,
    required this.description,
    required this.exercises,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }

  factory IATrainingResult.fromJson(Map<String, dynamic> json) {
    return IATrainingResult(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      exercises: List<ExerciseIA>.from(json['exercises'].map((x) => ExerciseIA.fromJson(x))),
    );
  }
}

class ExerciseIA {
  String? title;
  String? title1;
  String? title2;
  String? muscleId;
  String? obs;
  String? series;
  String? reps;
  int? peso;
  String? set_type;
  String? video;
  List<ExerciseIA>? sets;

  ExerciseIA({
    required this.title,
    required this.title1,
    required this.title2,
    required this.muscleId,
    required this.obs,
    required this.series,
    required this.reps,
    required this.peso,
    required this.set_type,
    required this.video,
    this.sets,
  });

  factory ExerciseIA.fromJson(Map<String, dynamic> json) {
    return ExerciseIA(
      title: json['title'] as String?,
      title1: json['title1'] as String?,
      title2: json['title2'] as String?,
      muscleId: json['muscleId'] as String?,
      obs: json['obs'] as String?,
      series: json['series'] as String?,
      reps: json['reps'] as String?,
      peso: json['peso'] is int? ? json['peso'] : int.parse(json['peso']),
      set_type: json['set_type'] as String?,
      video: json['video'] as String?,
      sets: json['sets'] != null
          ? List<ExerciseIA>.from(
              json['sets'].map((x) => ExerciseIA.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'title1': title1,
      'title2': title2,
      'muscleId': muscleId,
      'obs': obs,
      'series': series,
      'reps': reps,
      'peso': peso,
      'set_type': set_type,
      'video': video,
      'sets': sets?.map((exercise) => exercise.toJson()).toList(),
    };
  }
}
