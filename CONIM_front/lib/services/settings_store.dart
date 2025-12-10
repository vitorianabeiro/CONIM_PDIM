// lib/services/settings_store.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  static const String _key = 'app_settings';

  Future<void> save(Map<String, dynamic> settings) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(settings));
  }

  Future<Map<String, dynamic>?> load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_key);
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }
}
