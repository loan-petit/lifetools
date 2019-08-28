import 'package:flutter/material.dart';

import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/environment.dart';
import 'package:flutter_app/src/services/data_persistence_service.dart';

void main() async {
  // Setup production environment
  Environment.prod();

  // Load asynchronous services
  await DataPersistenceService().init();

  runApp(App());
}
