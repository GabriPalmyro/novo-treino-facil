class CoreApp {
  bool mostrarAdicionarExercicios;
  bool mostrarAjudas;
  bool mostrarAlterarSenha;
  bool mostrarTreinosFaceis;

  CoreApp({
    this.mostrarAdicionarExercicios,
    this.mostrarAjudas,
    this.mostrarAlterarSenha,
    this.mostrarTreinosFaceis,
  });

  Map<String, dynamic> toMap() {
    return {
      'adicionar_exercicios': mostrarAdicionarExercicios,
      'ajudas': mostrarAjudas,
      'alterar_senha': mostrarAlterarSenha,
      'treinos_faceis': mostrarTreinosFaceis,
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

  @override
  String toString() {
    return 'CoreApp(mostrarAdicionarExercicios: $mostrarAdicionarExercicios, mostrarAjudas: $mostrarAjudas, mostrarAlterarSenha: $mostrarAlterarSenha, mostrarTreinosFaceis: $mostrarTreinosFaceis)';
  }
}
