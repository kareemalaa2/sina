import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResponseModel {
  bool success;
  dynamic data;
  int total;
  String? message;
  String? token;
  ResponseModel({
    required this.success,
    required this.data,
    this.total = 0,
    this.message,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'data': data,
      'total': total,
      'message': message,
      'token': token,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      success: map['success'] as bool,
      data: map['data'] as dynamic,
      total: map['total'] != null ? int.parse(map['total'].toString()) : 0,
      message: map['message'] != null ? map['message'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) =>
      ResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
