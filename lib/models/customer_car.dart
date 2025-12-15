import 'package:mycar/models/car_company.dart';
import 'package:mycar/models/car_name.dart';

class CustomerCar {
  String id;
  String user;
  CarCompany carCompany;
  CarName carName;
  int carModel;
  String? chassiNo;
  String? plateNo;
  CustomerCar({
    required this.id,
    required this.user,
    required this.carCompany,
    required this.carName,
    required this.carModel,
    this.chassiNo,
    this.plateNo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'carCompany': carCompany.toMap(),
      'carName': carName.toMap(),
      'carModel': carModel,
      'chassisNo': chassiNo,
      'plateNo': plateNo,
    };
  }

  factory CustomerCar.fromMap(Map<String, dynamic> map) {
    return CustomerCar(
      id: map['id'] as String,
      user: map['user'] as String,
      carCompany: CarCompany.fromMap(map['carCompany'] as Map<String, dynamic>),
      carName: CarName.fromMap(map['carName'] as Map<String, dynamic>),
      carModel: int.parse(map['carModel'].toString()),
      chassiNo: map['chassisNo'] != null ? map['chassisNo'] as String : null,
      plateNo: map['plateNo'] != null ? map['plateNo'] as String : null,
    );
  }
}
