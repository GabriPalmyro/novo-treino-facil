class ExerciciosPlanilha {
  String id;
  int position;
  String title;
  String muscleId;
  String video;
  String series;
  String reps;
  int carga;
  String comments;
  String setType;

  ExerciciosPlanilha({
    this.id,
    this.position,
    this.title,
    this.muscleId,
    this.video,
    this.series,
    this.reps,
    this.carga,
    this.comments,
    this.setType,
  });

  Map<String, dynamic> toMap() {
    return {
      'pos': position,
      'title': title,
      'muscleId': muscleId,
      'video': video,
      'series': series,
      'reps': reps,
      'peso': carga,
      'obs': comments,
      'set_type': setType,
    };
  }

  factory ExerciciosPlanilha.fromMap(Map<String, dynamic> map) {
    return ExerciciosPlanilha(
      id: map['id'] as String,
      position: map['pos'] as int,
      title: map['title'] as String,
      muscleId: map['muscleId'] as String,
      video: map['video'] as String,
      series: map['series'] as String,
      reps: map['reps'] as String,
      carga: map['peso'] as int,
      comments: map['obs'] as String,
      setType: map['set_type'] as String,
    );
  }

  @override
  String toString() {
    return 'TrainingWorksheet(position: $position, title: $title, muscleId: $muscleId, video: $video, series: $series, reps: $reps, carga: $carga, comments: $comments, setType: $setType)';
  }
}
