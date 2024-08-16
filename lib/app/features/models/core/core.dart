class CoreApp {
  bool? mostrarAdicionarExercicios;
  bool? mostrarAjudas;
  bool? mostrarAlterarSenha;
  bool? mostrarTreinosFaceis;
  bool? mostrarIaTraining;
  bool? showPremium;
  double? appPremiumPrice;

  CoreApp({
    this.mostrarAdicionarExercicios,
    this.mostrarAjudas,
    this.mostrarAlterarSenha,
    this.mostrarTreinosFaceis,
    this.mostrarIaTraining,
    this.showPremium,
    this.appPremiumPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'adicionar_exercicios': mostrarAdicionarExercicios,
      'ajudas': mostrarAjudas,
      'alterar_senha': mostrarAlterarSenha,
      'treinos_faceis': mostrarTreinosFaceis,
      'ia_training': mostrarIaTraining,
      'app_premium_price': appPremiumPrice,
      'show_premium': showPremium,
    };
  }

  factory CoreApp.fromMap(Map<String, dynamic> map) {
    return CoreApp(
      mostrarAdicionarExercicios: map['adicionar_exercicios'] ?? false,
      mostrarAjudas: map['ajudas'] ?? false,
      mostrarAlterarSenha: map['alterar_senha'] ?? false,
      mostrarTreinosFaceis: map['treinos_faceis'] ?? false,
      appPremiumPrice: double.tryParse(map['app_premium_price'].toString()),
      showPremium: map['showPremium'] ?? false,
    );
  }

  CoreApp copyWith({
    bool? mostrarAdicionarExercicios,
    bool? mostrarAjudas,
    bool? mostrarAlterarSenha,
    bool? mostrarTreinosFaceis,
    bool? mostrarIaTraining,
    bool? showPremium,
    double? appPremiumPrice,
  }) {
    return CoreApp(
      mostrarAdicionarExercicios: mostrarAdicionarExercicios ?? this.mostrarAdicionarExercicios,
      mostrarAjudas: mostrarAjudas ?? this.mostrarAjudas,
      mostrarAlterarSenha: mostrarAlterarSenha ?? this.mostrarAlterarSenha,
      mostrarTreinosFaceis: mostrarTreinosFaceis ?? this.mostrarTreinosFaceis,
      mostrarIaTraining: mostrarIaTraining ?? this.mostrarIaTraining,
      appPremiumPrice: appPremiumPrice ?? this.appPremiumPrice,
      showPremium: showPremium ?? this.showPremium,
    );
  }

  @override
  String toString() {
    return 'CoreApp(mostrarAdicionarExercicios: $mostrarAdicionarExercicios, mostrarAjudas: $mostrarAjudas, mostrarAlterarSenha: $mostrarAlterarSenha, mostrarTreinosFaceis: $mostrarTreinosFaceis, mostrarIaTraining: $mostrarIaTraining)';
  }
}
