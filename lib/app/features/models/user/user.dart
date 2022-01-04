import 'package:tabela_treino/app/core/core.dart';

class User {
  String id;
  String nickname;
  String name;
  String lastName;
  String email;
  String phoneNumber;
  String sex;
  String photoURL;
  bool isPersonal;
  bool isPayApp;
  int seguidores;
  int seguindo;
  //! PREFERENCIAS
  //* PLANILHAS
  bool mostrarPlanilhasPerfil;
  bool mostrarExerciciosPerfil;
  //* AMIGOS
  bool mostrarPerfilPesquisa;

  User(
      {this.id,
      this.nickname,
      this.name,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.photoURL,
      this.sex,
      this.isPersonal,
      this.isPayApp,
      this.seguidores,
      this.seguindo,
      this.mostrarExerciciosPerfil,
      this.mostrarPerfilPesquisa,
      this.mostrarPlanilhasPerfil});

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'name': name,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'photoURL': photoURL,
      'sex': sex,
      'personal_type': isPersonal,
      'payApp': isPayApp,
      'seguidores': seguidores,
      'seguindo': seguindo,
      'mostrar_planilhas_perfil': mostrarPlanilhasPerfil,
      'mostrar_exercicios_perfil': mostrarExerciciosPerfil,
      'mostrar_perfil_pesquisa': mostrarPerfilPesquisa,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String ?? '',
      nickname: map['nickname'] as String ?? '',
      name: map['name'] as String ?? '',
      lastName: map['last_name'] as String ?? '',
      email: map['email'] as String ?? '',
      phoneNumber: map['phone_number'] as String ?? '',
      photoURL: map['photoURL'] as String ?? AppTexts.photoURL,
      sex: map['sexo'] as String ?? '',
      isPersonal: map['personal_type'] as bool ?? false,
      isPayApp: map['payApp'] as bool ?? false,
      seguidores: map['seguidores'] as int ?? 0,
      seguindo: map['seguindo'] as int ?? 0,
      mostrarPlanilhasPerfil: map['mostrar_planilhas_perfil'] as bool ?? true,
      mostrarExerciciosPerfil: map['mostrar_exercicios_perfil'] as bool ?? true,
      mostrarPerfilPesquisa: map['mostrar_perfil_pesquisa'] as bool ?? true,
    );
  }

  @override
  String toString() {
    return 'User(nickname: $nickname, name: $name, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, sex: $sex, photoURL: $photoURL, isPersonal: $isPersonal, isPayApp: $isPayApp, seguidores: $seguidores, seguindo: $seguindo)';
  }
}
