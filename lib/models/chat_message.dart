import 'package:mycar/models/user.dart';

class ChatMessage {
  String id;
  User sender;
  String chat;
  bool isRating;
  bool read;
  String? message;
  String? user;
  String? attachment;
  String? attachmentType;
  double? lat;
  double? lng;
  int? rate;
  DateTime createdAt;
  ChatMessage({
    required this.id,
    required this.sender,
    required this.chat,
    required this.isRating,
    required this.read,
    this.message,
    this.user,
    this.attachment,
    this.attachmentType,
    this.lat,
    this.lng,
    this.rate,
    required this.createdAt,
  });

  bool get isFile =>
      attachmentType is String &&
      attachment is String &&
      attachmentType!.isNotEmpty &&
      attachment!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sender': sender.toMap(),
      'chat': chat,
      'isRating': isRating,
      'read': read,
      'message': message,
      'user': user,
      'attachment': attachment,
      'attachmentType': attachmentType,
      'lat': lat,
      'lng': lng,
      'rate': rate,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  bool isMine(String id) {
    return sender.id == id;
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['_id'] as String,
      sender: User.fromMap(map['sender'] as Map<String, dynamic>),
      chat: map['chat'] as String,
      isRating: map['isRating'] as bool,
      read: map['read'] as bool,
      message: map['message'] != null ? map['message'] as String : null,
      user: map['user'] != null ? map['user'] as String : null,
      attachment:
          map['attachment'] != null ? map['attachment'] as String : null,
      attachmentType: map['attachmentType'] != null
          ? map['attachmentType'] as String
          : null,
      lat: map['lat'] != null ? double.parse(map['lat'].toString()) : null,
      lng: map['lng'] != null ? double.parse(map['lng'].toString()) : null,
      rate: map['rate'] != null ? int.parse(map['rate'].toString()) : null,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
