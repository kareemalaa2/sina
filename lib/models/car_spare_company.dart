import 'package:mycar/models/car_company.dart';
import 'package:mycar/models/car_name.dart';
import 'package:mycar/models/user.dart';

import 'car_spare.dart';

class CarSpareCompany {
  String id;
  User? user;
  CarCompany? carCompany;
  CarName? carName;
  List<int> modelYears;
  CarSpare? carSpare;
  String condition;
  String? chassisNo;
  String? image;
  double? price;
  DateTime createdAt;
  CarSpareCompany({
    required this.id,
    this.user,
    this.carCompany,
    this.carName,
    required this.modelYears,
    this.carSpare,
    required this.condition,
    this.chassisNo,
    this.image,
    this.price,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'carCompany': carCompany?.toMap(),
      'carName': carName?.toMap(),
      'modelYears': modelYears,
      'carSpare': carSpare?.toMap(),
      'condition': condition,
      'chassisNo': chassisNo,
      'image': image,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CarSpareCompany.fromMap(Map<String, dynamic> map) {
    return CarSpareCompany(
      id: map['_id'] as String,
      user: map['user'] is! String && map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      carCompany: map['carCompany'] != null && map['carCompany'] is Map<String, dynamic>
          ? CarCompany.fromMap(map['carCompany'] as Map<String, dynamic>)
          : null,
      carName: map['carName'] != null && map['carName'] is Map<String, dynamic>
          ? CarName.fromMap(map['carName'] as Map<String, dynamic>)
          : null,
      modelYears: List<int>.generate(map['modelYears'].length,
          (i) => int.parse(map['modelYears'][i].toString())),
      carSpare: map['carSpare'] != null && map['carSpare'] is Map<String, dynamic>
          ? CarSpare.fromMap(map['carSpare'] as Map<String, dynamic>)
          : null,
      condition: map['condition'] as String,
      chassisNo: map['chassisNo'] != null ? map['chassisNo'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      price:
          map['price'] != null ? double.parse(map['price'].toString()) : null,
      createdAt: DateTime.parse(map['createdAt'].toString()).toLocal(),
    );
  }
}