class CoreApp {
  bool? mostrarAdicionarExercicios;
  bool? mostrarAjudas;
  bool? mostrarAlterarSenha;
  bool? mostrarTreinosFaceis;
  bool? mostrarIaTraining;

  CoreApp({
    this.mostrarAdicionarExercicios,
    this.mostrarAjudas,
    this.mostrarAlterarSenha,
    this.mostrarTreinosFaceis,
    this.mostrarIaTraining,
  });

  Map<String, dynamic> toMap() {
    return {
      'adicionar_exercicios': mostrarAdicionarExercicios,
      'ajudas': mostrarAjudas,
      'alterar_senha': mostrarAlterarSenha,
      'treinos_faceis': mostrarTreinosFaceis,
      'ia_training': mostrarIaTraining,
    };
  }

  factory CoreApp.fromMap(Map<String, dynamic> map) {
    return CoreApp(
      mostrarAdicionarExercicios: map['adicionar_exercicios'] ?? false,
      mostrarAjudas: map['ajudas'] ?? false,
      mostrarAlterarSenha: map['alterar_senha'] ?? false,
      mostrarTreinosFaceis: map['treinos_faceis'] ?? false,
    );
  }

  CoreApp copyWith({
    bool? mostrarAdicionarExercicios,
    bool? mostrarAjudas,
    bool? mostrarAlterarSenha,
    bool? mostrarTreinosFaceis,
    bool? mostrarIaTraining,
  }) {
    return CoreApp(
      mostrarAdicionarExercicios: mostrarAdicionarExercicios ?? this.mostrarAdicionarExercicios,
      mostrarAjudas: mostrarAjudas ?? this.mostrarAjudas,
      mostrarAlterarSenha: mostrarAlterarSenha ?? this.mostrarAlterarSenha,
      mostrarTreinosFaceis: mostrarTreinosFaceis ?? this.mostrarTreinosFaceis,
      mostrarIaTraining: mostrarIaTraining ?? this.mostrarIaTraining,
    );
  }

  @override
  String toString() {
    return 'CoreApp(mostrarAdicionarExercicios: $mostrarAdicionarExercicios, mostrarAjudas: $mostrarAjudas, mostrarAlterarSenha: $mostrarAlterarSenha, mostrarTreinosFaceis: $mostrarTreinosFaceis, mostrarIaTraining: $mostrarIaTraining)';
  }
}
