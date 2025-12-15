import 'car_company.dart';
import 'car_name.dart';

class UserCar {
  String id;
  CarName? carName;
  CarCompany? carCompany;
  int carModel;
  String? chassisNo;
  String? plateNo;
  UserCar({
    required this.id,
    this.carName,
    this.carCompany,
    required this.carModel,
    this.chassisNo,
    this.plateNo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'carName': carName?.toMap(),
      'carCompany': carCompany?.toMap(),
      'carModel': carModel,
      'chassisNo': chassisNo,
      'plateNo': plateNo,
    };
  }

  factory UserCar.fromMap(Map<String, dynamic> map) {
    return UserCar(
      id: map['_id'] as String,
      carName: map['carName'] != null
          ? CarName.fromMap(map['carName'] as Map<String, dynamic>)
          : null,
      carCompany: map['carCompany'] != null && map['carCompany'] is! String
          ? CarCompany.fromMap(map['carCompany'] as Map<String, dynamic>)
          : null,
      carModel: int.parse(map['carModel'].toString()),
      chassisNo: map['chassisNo'] != null ? map['chassisNo'] as String : null,
      plateNo: map['plateNo'] != null ? map['plateNo'] as String : null,
    );
  }
}
