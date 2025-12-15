// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationData {
  String id;
  String titleAr;
  String titleEn;
  String? bodyAr;
  String? bodyEn;
  String? imageUrl;
  DateTime createdAt;
  NotificationData({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.bodyAr,
    this.bodyEn,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'bodyAr': bodyAr,
      'bodyEn': bodyEn,
      'imageUrl': imageUrl,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      id: map['_id'] as String,
      titleAr: map['titleAr'] as String,
      titleEn: map['titleEn'] as String,
      bodyAr: map['bodyAr'] != null ? map['bodyAr'] as String : null,
      bodyEn: map['bodyEn'] != null ? map['bodyEn'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
