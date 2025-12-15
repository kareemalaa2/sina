import 'package:flutter/material.dart';
import 'package:mycar/models/country.dart';
import 'package:mycar/utils/extensions.dart';

class LoginInfo {
  TextEditingController country = TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  ValueNotifier<bool> isUpSecure = ValueNotifier(true);
  ValueNotifier<bool> loading = ValueNotifier(false);

  Map<String, dynamic> getMap(List<Country> countries) {
    String tel = phone.text.replaceArabicNumber();
    if (tel[0] == "0") {
      tel = tel.substring(1);
    }
    return {
      "phone":
          "${countries.where((x) => x.id == country.text).firstOrNull?.phoneCode}$tel",
      "password": password.text,
    };
  }
}