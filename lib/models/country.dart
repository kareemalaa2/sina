// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../generated/l10n.dart';

class Country {
  String id;
  String nameAr;
  String nameEn;
  String currency;
  String flag;
  double currencyAmount;
  int phoneCode;
  Country({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.currency,
    required this.flag,
    this.currencyAmount = 0,
    required this.phoneCode,
  });

  String get name => S.current.locale == "ar" ? nameAr : nameEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'flag': flag,
      'phoneCode': phoneCode,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['_id'] as String,
      nameAr: map['nameAr'] as String,
      nameEn: map['nameEn'] as String,
      currency: map['currency'] as String,
      flag: map['flag'] as String,
      phoneCode: int.parse((map['phoneCode'] ?? "966").toString()),
      currencyAmount: double.parse((map['currencyAmount'] ?? "0").toString()),
    );
  }
}
