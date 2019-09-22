/// Inform that data persistence isn't supported on this platform.
class DataPersistenceService {
  static final DataPersistenceService _singleton =
      DataPersistenceService._internal();

  factory DataPersistenceService() {
    return _singleton;
  }

  DataPersistenceService._internal();

  /// Calls every asynchronous operations needed to initialize the class.
  Future<void> init() async {
    throw Exception('Platform Not Supported');
  }

  /// Set a field with the key [key] to [value].
  void set(String key, String value) {
    throw Exception('Platform Not Supported');
  }

  /// Get the field associated to the [key].
  String get(String key) {
    throw Exception('Platform Not Supported');
  }

  /// Remove the field associated to the [key].
  void remove(String key) {
    throw Exception('Platform Not Supported');
  }
}
