class Aluno {
  String id;
  String alunoId;
  String alunoEmail;
  String alunoName;
  String alunoNumero;
  String alunoPhoto;

  Aluno({
    this.id,
    this.alunoId,
    this.alunoEmail,
    this.alunoName,
    this.alunoNumero,
    this.alunoPhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'client_id': alunoId,
      'client_email': alunoEmail,
      'client_name': alunoName,
      'client_phoneNumber': alunoNumero,
      'client_photo': alunoPhoto,
    };
  }

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      alunoId: map['client_id'],
      alunoEmail: map['client_email'],
      alunoName: map['client_name'],
      alunoNumero: map['client_phoneNumber'],
      alunoPhoto: map['client_photo'],
    );
  }

  @override
  String toString() {
    return 'Aluno(id: $id, alunoId: $alunoId, alunoName: $alunoName, alunoNumero: $alunoNumero, alunoPhoto: $alunoPhoto)';
  }
}
