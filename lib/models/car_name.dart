import '../generated/l10n.dart';

class CarName {
  String id;
  String nameAr;
  String nameEn;
  CarName({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  String get name => S.current.locale == "ar" ? nameAr : nameEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }

  factory CarName.fromMap(Map<String, dynamic> map) {
    return CarName(
      id: map['_id'] as String,
      nameAr: map['nameAr'] as String,
      nameEn: map['nameEn'] as String,
    );
  }
}
