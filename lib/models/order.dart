// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/service_style.dart.dart';

import 'car_spare_company.dart';
import 'user.dart';
import 'user_car.dart';

class Order {
  String id;
  String userId;
  User? user;
  String? serviceProviderId;
  User? serviceProvider;
  String serviceStyleId;
  ServiceStyle? serviceStyle;
  UserCar? userCar;
  CarSpareCompany? carSpare;
  String status;
  String serviceType;
  String? problemDesc;
  String? attachment;
  String? attachmentType;
  DateTime createdAt;
  Order({
    required this.id,
    required this.userId,
    this.user,
    this.serviceProviderId,
    this.serviceProvider,
    required this.serviceStyleId,
    this.serviceStyle,
    this.userCar,
    this.carSpare,
    required this.status,
    required this.serviceType,
    this.problemDesc,
    this.attachment,
    this.attachmentType,
    required this.createdAt,
  });

  String get place =>
      serviceType == "atPlace" ? S.current.atPlace : S.current.atShop;

  String get statusTranslated {
    switch (status) {
      case "pending":
        return S.current.orderPending;
      case "active":
        return S.current.orderActive;
      case "canceled":
        return S.current.orderCanceled;
      case "completed":
        return S.current.orderCompleted;
      default:
        return S.current.orderPending;
    }
  } 

  IconData get statusIcon {
    switch (status) {
      case "pending":
        return Icons.timer;
      case "active":
        return Icons.stacked_bar_chart;
      case "canceled":
        return Icons.cancel;
      case "completed":
        return Icons.check_circle;
      default:
        return Icons.timer;
    }
  }

  Color get statusColor {
    switch (status) {
      case "pending":
        return Colors.blue;
      case "active":
        return Colors.brown;
      case "canceled":
        return Colors.red;
      case "completed":
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'user': user?.toMap(),
      'serviceProviderId': serviceProviderId,
      'serviceProvider': serviceProvider?.toMap(),
      'serviceStyleId': serviceStyleId,
      'serviceStyle': serviceStyle?.toMap(),
      'status': status,
      'serviceType': serviceType,
      'problemDesc': problemDesc,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      userId: map['user'] is! String
          ? map['user']['_id'] as String
          : map['user'] as String,
      user: map['user'] is! String
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      serviceProviderId:
          map['serviceProvider'] is! String && map['serviceProvider'] != null
              ? map['serviceProvider']['_id'] as String
              : map['serviceProvider'] is String
                  ? map['serviceProvider'] as String
                  : null,
      serviceProvider:
          map['serviceProvider'] is! String && map['serviceProvider'] != null
              ? User.fromMap(map['serviceProvider'] as Map<String, dynamic>)
              : null,
      carSpare: map['carSpare'] is! String && map['carSpare'] != null
          ? CarSpareCompany.fromMap(map['carSpare'] as Map<String, dynamic>)
          : null,
      serviceStyleId: map['serviceStyle'] is! String
          ? map['serviceStyle']['_id'] as String
          : map['serviceStyle'] as String,
      serviceStyle: map['serviceStyle'] is! String
          ? ServiceStyle.fromMap(map['serviceStyle'] as Map<String, dynamic>)
          : null,
      status: map['status'] as String,
      userCar: map['userCar'] != null && map['userCar'] is! String
          ? UserCar.fromMap(map['userCar'])
          : null,
      serviceType: map['serviceType'] as String,
      problemDesc:
          map['problemDesc'] != null ? map['problemDesc'] as String : null,
      attachment:
          map['attachment'] != null ? map['attachment'] as String : null,
      attachmentType: map['attachmentType'] != null
          ? map['attachmentType'] as String
          : null,
      createdAt: DateTime.parse(map['createdAt'].toString()).toLocal(),
    );
  }
}
