import 'package:flutter/material.dart';

import 'package:lifetools/src/app.dart';
import 'package:lifetools/src/environment.dart';
import 'package:lifetools/src/services/data_persistence_service/index.dart';

void main() async {
  // Setup developement environment
  Environment.dev();

  WidgetsFlutterBinding.ensureInitialized();

  // Load asynchronous services
  await DataPersistenceService().init();

  runApp(App());
}
