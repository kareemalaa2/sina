import 'package:mycar/generated/l10n.dart';

class ServiceStyle {
  String id;
  String nameAr;
  String nameEn;
  String icon;
  String key;
  double subscriptionFee;
  ServiceStyle({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.key,
    required this.subscriptionFee,
  });

  String get name => S.current.locale == "ar" ? nameAr : nameEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'icon': icon,
      'key': key,
      'subscriptionFee': subscriptionFee,
    };
  }

//Key
  factory ServiceStyle.fromMap(Map<String, dynamic> map) {
    return ServiceStyle(
      id: map['_id'] as String,
      nameAr: map['nameAr'] as String,
      nameEn: map['nameEn'] as String,
      icon: map['icon'] as String,
      key: map['key'] as String,
      subscriptionFee: double.parse(map['subscriptionFee'].toString()),
    );
  }
}
