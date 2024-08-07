class DiaDaSemana {
  String dia;
  bool isSelected;

  DiaDaSemana({
    required this.dia,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {'dia': dia, 'isSelected': isSelected};
  }

  factory DiaDaSemana.fromMap(Map<String, dynamic> map) {
    return DiaDaSemana(
      dia: map['dia'] as String,
      isSelected: map['isSelected'] as bool,
    );
  }

  @override
  String toString() => 'DiaDaSemana(dia: $dia, isSelected: $isSelected)';
}
