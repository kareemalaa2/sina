import 'package:mycar/generated/l10n.dart';

class Ad {
  String id;
  String image;
  String descAr;
  String descEn;
  String? whatsapp;
  String? link;
  Ad({
    required this.id,
    required this.image,
    required this.descAr,
    required this.descEn,
    this.whatsapp,
    this.link,
  });

  String get desc => S.current.locale == "ar" ? descAr : descEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'descAr': descAr,
      'descEn': descEn,
      'whatsapp': whatsapp,
      'link': link,
    };
  }

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      id: map['_id'] as String,
      image: map['image'] as String,
      descAr: map['descAr'] as String,
      descEn: map['descEn'] as String,
      whatsapp: map['whatsapp'] != null ? map['whatsapp'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
    );
  }
}
