import 'package:flutter/material.dart';

import 'package:lifetools/src/app.dart';
import 'package:lifetools/src/environment.dart';
import 'package:lifetools/src/services/data_persistence_service.dart';
import 'package:lifetools/src/utils/graphql/graphql_helper.dart';

void main() async {
  // Setup production environment
  Environment.prod();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and helpers
  await DataPersistenceService().init();
  GraphQLHelper().init();

  runApp(App());
}
