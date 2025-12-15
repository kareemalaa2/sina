// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mycar/models/car_name.dart';

import '../generated/l10n.dart';

class CarCompany {
  String id;
  String nameAr;
  String nameEn;
  List<CarName> carNames;
  String logo;
  CarCompany({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.carNames,
    required this.logo,
  });

  String get name => S.current.locale == "ar" ? nameAr : nameEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'logo': logo,
    };
  }

  factory CarCompany.fromMap(Map<String, dynamic> map) {
    return CarCompany(
      id: map['_id'] as String,
      nameAr: map['nameAr'] as String,
      nameEn: map['nameEn'] as String,
      carNames: map['carNames'] != null
          ? List.generate(
              map['carNames'].length,
              (i) => CarName.fromMap(
                map['carNames'][i],
              ),
            )
          : [],
      logo: map['logo'] as String,
    );
  }
}
