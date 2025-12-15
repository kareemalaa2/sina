import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AppProvider extends ChangeNotifier {
  late SharedPreferences _sh;
  late BuildContext _context;
  late Directory _temp;
  late Directory _downloadDir;
  List<CameraDescription> _cameras = <CameraDescription>[];
  Locale? _locale;
  User? _user;

  Locale? get locale => _locale;
  User? get user => _user;
  List<CameraDescription> get cameras => _cameras;
  BuildContext get context => _context;
  Directory get temp => _temp;
  Directory get downloadDir => _downloadDir;

  Future<AppProvider> init(SharedPreferences shared) async {
_downloadDir = await getApplicationDocumentsDirectory();
    _temp = await getTemporaryDirectory();
    _sh = shared;
    if (shared.getString("locale") is String) {
      _locale = Locale(shared.getString("locale").toString());
    }
    _cameras = await availableCameras();
    return this;
  }

  setLocale(String val) async {
    _locale = Locale(val);
    await _sh.setString("locale", val);
    notifyListeners();
  }

  setContext(BuildContext ctx) {
    _context = ctx;
  }
}
