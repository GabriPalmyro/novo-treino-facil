import 'package:tabela_treino/app/features/models/planilha/dia_da_semana.dart';

class Planilha {
  String? id;
  String? title;
  String? description;
  bool? favorito;
  List<DiaDaSemana>? diasDaSemana;

  Planilha(
      {this.id,
      this.title,
      this.description,
      this.diasDaSemana,
      this.favorito});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'favorito': favorito,
      'diasDaSemana': diasDaSemana?.map((x) => x.toMap()).toList(),
    };
  }

  factory Planilha.fromMap(Map<String, dynamic> map) {
    return Planilha(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        favorito: map['favorito'] as bool ?? false,
        diasDaSemana: map['diasDaSemana'] == null
            ? listDiasDaSemana
            : List<DiaDaSemana>.from(
                map['diasDaSemana']?.map((x) => DiaDaSemana.fromMap(x))));
  }

  @override
  String toString() {
    return 'Planilha(id: $id, title: $title, description: $description, favorito: $favorito)';
  }
}

List<DiaDaSemana> listDiasDaSemana = [
  DiaDaSemana(dia: 'Segunda-Feira', isSelected: false),
  DiaDaSemana(dia: 'Terça-Feira', isSelected: false),
  DiaDaSemana(dia: 'Quarta-Feira', isSelected: false),
  DiaDaSemana(dia: 'Quinta-Feira', isSelected: false),
  DiaDaSemana(dia: 'Sexta-Feira', isSelected: false),
  DiaDaSemana(dia: 'Sábado', isSelected: false),
  DiaDaSemana(dia: 'Domingo', isSelected: false),
];
