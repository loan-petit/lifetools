import 'package:flutter_web/material.dart';

import 'package:flutter_app/src/app.dart';
import 'package:flutter_app/src/environment.dart';
import 'package:flutter_app/src/services/data_persistence_service.dart';

void main() async {
  // Setup developement environment
  Environment.dev();

  // Load asynchronous services
  await DataPersistenceService().init();

  runApp(App());
}
