import 'dart:html';

/// Manage the persistence of the application's data on the device.
/// This class is a Singleton.
class DataPersistenceService {
  static final DataPersistenceService _singleton =
      DataPersistenceService._internal();

  /// Data persistence helper for web apps.
  final Storage _localStorage = window.localStorage;

  factory DataPersistenceService() {
    return _singleton;
  }

  DataPersistenceService._internal();

  /// Calls every asynchronous operations needed to initialize the class.
  Future<void> init() async {}

  /// Set a field with the key [key] to [value].
  void set(String key, String value) {
    _localStorage[key] = value;
  }

  /// Get the field associated to the [key].
  String get(String key) {
    return _localStorage[key];
  }

  /// Remove the field associated to the [key].
  void remove(String key) {
    _localStorage.remove(key);
  }
}
