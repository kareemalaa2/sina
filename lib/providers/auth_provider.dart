import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
// import 'package:location/location.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../generated/l10n.dart';
import '../models/country.dart';
import '../models/user.dart';
import '../route_generator.dart';
import 'contexts/login_info.dart';

class AuthProvider extends ChangeNotifier {
  late SharedPreferences _sh;
  // final Location _location = Location();
  Position? _locationData;
  Country? _currentCountry;
  List<Country> _countries = [];
  Locale? _locale;
  User? _user;
  String? _token;
  io.Socket? _socket;
  bool _notify = false;
  final LoginInfo _loginInfo = LoginInfo();

  Locale? get locale => _locale;
  Position? get locationData => _locationData;
  Country? get currentCountry => _currentCountry;
  User? get user => _user;
  String? get token => _token;
  io.Socket? get socket => _socket;
  LoginInfo get loginInfo => _loginInfo;
  List<Country> get countries => _countries;
  bool get notify => _notify;

  Future<AuthProvider> init(SharedPreferences shared) async {
    _sh = shared;
    if (shared.getString("locale") is String) {
      _locale = Locale(shared.getString("locale").toString());
    }
    if (shared.getString("token") is String) {
      _token = shared.getString("token").toString();
    }
    _notify = _sh.getBool("isNotified") is! bool;
    await loadCountries();
    await getUserInfo();
    await aquireLocation();
    return this;
  }

  setLocale(String val) async {
    _locale = Locale(val);
    await _sh.setString("locale", val);
    notifyListeners();
  }

  setToken(String val) async {
    _token = val;
    await _sh.setString("token", val);
    notifyListeners();
  }

  setNewKey(GlobalKey<FormState> key) {
    _loginInfo.form = key;
  }

  socketConnect() {
    _socket = io.io(
      "https://api.sinaeiati.com/user",
      io.OptionBuilder()
          .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
          .enableAutoConnect()
          .setQuery({
            'token': token,
          })
          .enableForceNew()
          .build(),
    );
    socket?.onConnect((_) {
      debugPrint('connect');
      debugPrint("socket user => ${user!.id}");
      socket?.on(user!.id, (data) {
        _user = User.fromMap(data);
        notifyListeners();
      });
    });
    socket?.onDisconnect(
      (_) => debugPrint('disconnect'),
    );
    socket?.onConnectError(
      (msg) => debugPrint(msg.toString()),
    );
  }

  Future<bool> aquireLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    _locationData = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    if (_locationData is Position) {
      await _sh.setDouble("lat", _locationData!.latitude);
      await _sh.setDouble("lng", _locationData!.longitude);
      final resp = await ApiService.get("/countries/current", queryParams: {
        "lat": _locationData?.latitude,
        "lng": _locationData?.longitude,
      });
      if (resp.success && resp.data != null) {
        _currentCountry = Country.fromMap(resp.data);
      }
    }
    notifyListeners();
    return true;
  }login(BuildContext ctx) async {
  if (loginInfo.form.currentState!.validate() && !loginInfo.loading.value) {
    loginInfo.loading.value = true;
    final resp = await ApiService.post(
      "/users/login",
      loginInfo.getMap(countries),
      token: _token,
    );
    
    if (resp.success) {
      // Add null check for token
      if (resp.token == null) {
        loginInfo.loading.value = false;
        debugPrint('Login successful but no token received');
        if (!ctx.mounted) return;
        
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white),
                const Gap(10),
                Expanded(
                  child: Text(
                    S.current.wrongCredentials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        return;
      }
      
      _token = resp.token;
      await _sh.setString("token", resp.token!);
      final val = await getUserInfo();
      
      loginInfo.loading.value = false;
      
      // CRITICAL: Check if context is still mounted before navigation
      if (!ctx.mounted) return;
      
      if (val) {
        // Use go instead of goNamed to replace the entire stack
        if (user?.serviceStyle is ServiceStyle) {
          ctx.go('/provider-home');
        } else {
          ctx.go('/customer-home');
        }
      }
    } else {
      loginInfo.loading.value = false;
      debugPrint(resp.message);
      
      if (!ctx.mounted) return;
      
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Colors.white,
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  S.current.wrongCredentials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    notifyListeners();
  }
}
  Future<bool> getUserInfo() async {
    if (_token is String) {
      final resp = await ApiService.get(
        "/users",
        token: _token,
      );
      if (resp.success) {
        _user = User.fromMap(resp.data);
        if (_user is User &&
            _user?.serviceStyle is ServiceStyle &&
            _sh.getBool("isNotified") is! bool) {
          _notify = true;
          _sh.setBool("isNotified", true);
        }
        loginInfo.loading.value = false;
        // if (Platform.isIOS) {
        FirebaseMessaging.instance.requestPermission();
        // }
        FirebaseMessaging.instance.getToken().then((fcm) async {
          if (fcm is String) {
            await _sh.setString("fcm", fcm);
          }
        }).catchError((err) {
          debugPrint(err.toString());
        });
        socketConnect();
      }
      notifyListeners();
      return resp.success;
    } else {
      return false;
    }
  }

  loadCountries() async {
    final resp = await ApiService.get("/countries");
    if (resp.success) {
      _countries =
          List.generate(resp.data.length, (i) => Country.fromMap(resp.data[i]));
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    await _sh.remove("token");
    await FirebaseMessaging.instance.deleteToken();
    _token = null;
    _user = null;
    notifyListeners();
    return true;
  }
}