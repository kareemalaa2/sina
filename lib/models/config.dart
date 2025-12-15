import 'package:mycar/generated/l10n.dart';

class Config {
  String descAr;
  String descEn;
  Config({
    required this.descAr,
    required this.descEn,
  });

  String get desc => S.current.locale == "ar" ? descAr : descEn;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'descAr': descAr,
      'descEn': descEn,
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      descAr: map['descAr'] as String,
      descEn: map['descEn'] as String,
    );
  }
}
