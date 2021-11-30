class User {
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

  User(
      {this.name,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.photoURL,
      this.sex,
      this.isPersonal,
      this.isPayApp,
      this.seguidores,
      this.seguindo});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'photoURL': photoURL,
      'sex': sex,
      'personal_type': isPersonal,
      'payApp': isPayApp,
      'seguidores': seguidores,
      'seguindo': seguindo
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        name: map['name'] as String,
        lastName: map['last_name'] as String,
        email: map['email'] as String,
        phoneNumber: map['phone_number'] as String,
        photoURL: map['photoURL'] as String,
        sex: map['sexo'] as String,
        isPersonal: map['personal_type'] as bool,
        isPayApp: map['payApp'] as bool,
        seguidores: map['seguidores'] as int ?? 0,
        seguindo: map['seguindo'] as int ?? 0);
  }

  @override
  String toString() {
    return 'User(name: $name, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, sex: $sex, photoURL: $photoURL, isPersonal: $isPersonal, isPayApp: $isPayApp, seguidores: $seguidores, seguindo: $seguindo)';
  }
}
