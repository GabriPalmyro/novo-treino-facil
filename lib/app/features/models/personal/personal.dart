import 'package:tabela_treino/app/helpers/date_format.dart';

class Personal {
  String id;
  String personalId;
  String personalName;
  String personalEmail;
  String personalPhone;
  String personalPhoto;
  DateTime connectionDate;

  Personal({
    this.id,
    this.personalId,
    this.personalName,
    this.personalEmail,
    this.personalPhone,
    this.personalPhoto,
    this.connectionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'personal_Id': personalId,
      'personal_name': personalName,
      'personal_email': personalEmail,
      'personal_phoneNumber': personalPhone,
      'personal_photo': personalPhoto,
      'connection_date': connectionDate.millisecondsSinceEpoch,
    };
  }

  factory Personal.fromMap(Map<String, dynamic> map) {
    return Personal(
      id: map['id'] as String,
      personalId: map['personal_Id'] as String,
      personalName: map['personal_name'] as String,
      personalEmail: map['personal_email'] as String,
      personalPhone: map['personal_phoneNumber'] as String,
      personalPhoto: map['personal_photo'] as String,
      connectionDate: dateFormat(map['connection_date'] as String),
    );
  }

  @override
  String toString() {
    return 'Personal(id: $id, personalId: $personalId, personalName: $personalName, personalEmail: $personalEmail, personalPhone: $personalPhone, personalPhoto: $personalPhoto, connectionDate: $connectionDate)';
  }
}
