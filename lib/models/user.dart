// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mycar/models/country.dart';
import 'package:mycar/models/service_style.dart.dart';

class User {
  String id;
  String name;
  String phone;
  String? avatar;
  String? cover;
  String? bio;
  ServiceStyle? serviceStyle;
  Country country;
  String? socket;
  String? refreshToken;
  String? fcmToken;
  List<String> serviceType;
  String rating;
  String dist;
  bool isFav;
  DateTime validUntil;
  User({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar,
    this.cover,
    this.bio,
    this.serviceStyle,
    required this.country,
    this.socket,
    this.refreshToken,
    this.fcmToken,
    required this.serviceType,
    this.rating = "0.0",
    this.dist = "0",
    this.isFav = false,
    required this.validUntil,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'cover': cover,
      'bio': bio,
      'serviceStyle': serviceStyle?.toMap(),
      'country': country.toMap(),
      'socket': socket,
      'refreshToken': refreshToken,
      'fcmToken': fcmToken,
      'serviceType': serviceType,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      cover: map['cover'] != null ? map['cover'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      serviceStyle: map['serviceStyle'] != null &&
              map['serviceStyle'] is! String
          ? ServiceStyle.fromMap(map['serviceStyle'] as Map<String, dynamic>)
          : null,
      country: map['country'] is String
          ? Country(
              id: "id",
              nameAr: "nameAr",
              nameEn: "nameEn",
              currency: "currency",
              flag: "flag",
              phoneCode: 966,
            )
          : Country.fromMap(map['country'] as Map<String, dynamic>),
      socket: map['socket'] != null ? map['socket'] as String : null,
      refreshToken:
          map['refreshToken'] != null ? map['refreshToken'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      rating: map['rating'] != null
          ? double.parse((map['rating'] ?? 0).toString()).toStringAsFixed(1)
          : "0.0",
      dist: map['dist'] != null
          ? double.parse(((map['dist'] ?? 0) / 1000).toString())
              .toStringAsFixed(1)
          : "0.0",
      validUntil: DateTime.parse(map['validUntil'].toString()).toLocal(),
      isFav:
          map['isFav'] != null ? int.parse(map['isFav'].toString()) > 0 : false,
      serviceType: List<String>.generate(
        map['serviceType'].length,
        (i) => map['serviceType'][i].toString(),
      ),
    );
  }
}
