import 'package:shared_preferences/shared_preferences.dart';

/// Manage the persistence of the application's data on the device.
/// This class is a Singleton.
class DataPersistenceService {
  static final DataPersistenceService _singleton =
      DataPersistenceService._internal();

  /// Data persistence helper for native apps.
  SharedPreferences _prefs;

  factory DataPersistenceService() {
    return _singleton;
  }

  DataPersistenceService._internal();

  /// Calls every asynchronous operations needed to initialize the class.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Set a field with the key [key] to [value].
  void set(String key, String value) {
    _prefs.setString(key, value);
  }

  /// Get the field associated to the [key].
  String get(String key) {
    return _prefs.getString(key);
  }

  /// Remove the field associated to the [key].
  void remove(String key) {
    _prefs.remove(key);
  }
}
