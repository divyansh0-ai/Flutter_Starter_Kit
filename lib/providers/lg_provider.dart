import 'package:flutter/material.dart';
import 'package:flutter_lg_starter_kit/models/lg_config.dart';
import 'package:flutter_lg_starter_kit/services/kml_service.dart';
import 'package:flutter_lg_starter_kit/services/lg_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LGProvider extends ChangeNotifier {
  LGService? _lgService;
  KMLService? _kmlService;
  bool _isConnected = false;
  LGConfig? _config;

  bool get isConnected => _isConnected;
  LGConfig? get config => _config;
  KMLService? get kml => _kmlService;

  LGProvider() {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('lg_ip');
    if (ip != null) {
      _config = LGConfig(
        ip: ip,
        port: prefs.getInt('lg_port') ?? 22,
        username: prefs.getString('lg_username') ?? 'lg',
        password: prefs.getString('lg_password') ?? 'lg',
        screens: prefs.getInt('lg_screens') ?? 3,
      );
      _lgService = LGService(_config!);
      _kmlService = KMLService(_lgService!);
      notifyListeners();
    }
  }

  Future<bool> connect(LGConfig config) async {
    _config = config;
    _lgService = LGService(config);
    _kmlService = KMLService(_lgService!);
    _isConnected = await _lgService!.connect();

    if (_isConnected) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lg_ip', config.ip);
      await prefs.setInt('lg_port', config.port);
      await prefs.setString('lg_username', config.username);
      await prefs.setString('lg_password', config.password);
      await prefs.setInt('lg_screens', config.screens);
    }

    notifyListeners();
    return _isConnected;
  }

  Future<void> flyTo(double lat, double lng, {double zoom = 5000}) async {
    if (!_isConnected) return;
    await _lgService?.flyTo(lat, lng, zoom, 0, 0);
  }

  Future<void> sendKML(String kml) async {
    if (!_isConnected) return;
    await _lgService?.sendKML(kml);
  }

  Future<void> clear() async {
    if (!_isConnected) return;
    await _lgService?.clearKML();
  }
}
