import 'exercicios_planilha.dart';

class BiSetExercise {
  String id;

  int position;
  String setType;
  String firstExercise;
  String secondExercise;
  List<ExerciciosPlanilha> exercicios;

  BiSetExercise({
    this.id,
    this.position,
    this.setType,
    this.firstExercise,
    this.secondExercise,
    this.exercicios,
  });

  Map<String, dynamic> toMap() {
    return {
      'pos': position,
      'set_type': setType,
      'title1': firstExercise,
      'title2': secondExercise,
    };
  }

  factory BiSetExercise.fromMap(Map<String, dynamic> map) {
    return BiSetExercise(
      id: map['id'] as String,
      position: map['pos'] as int,
      setType: map['set_type'] as String,
      firstExercise: map['title1'] as String,
      secondExercise: map['title2'] as String,
    );
  }

  @override
  String toString() {
    return 'BiSetExercise(id: $id, position: $position, setType: $setType, firstExercise: $firstExercise, secondExercise: $secondExercise)';
  }
}
