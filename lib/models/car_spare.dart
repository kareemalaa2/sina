import '../generated/l10n.dart';

class CarSpare {
  String id;
  String nameAr;
  String nameEn;
  DateTime createdAt;
  CarSpare({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.createdAt,
  });

  String get name => S.current.locale == "ar" ? nameAr : nameEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CarSpare.fromMap(Map<String, dynamic> map) {
    return CarSpare(
      id: map['_id'] as String,
      nameAr: map['nameAr'] as String,
      nameEn: map['nameEn'] as String,
      createdAt: DateTime.parse(map['createdAt'].toString()).toLocal(),
    );
  }
}
