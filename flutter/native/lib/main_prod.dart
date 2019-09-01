import 'package:flutter/material.dart';

import 'package:LifeTools/src/app.dart';
import 'package:LifeTools/src/environment.dart';
import 'package:LifeTools/src/services/data_persistence_service.dart';

void main() async {
  // Setup production environment
  Environment.prod();

  // Load asynchronous services
  await DataPersistenceService().init();

  runApp(App());
}
