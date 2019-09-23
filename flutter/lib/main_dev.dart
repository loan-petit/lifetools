import 'package:flutter/material.dart';

import 'package:lifetools/src/app.dart';
import 'package:lifetools/src/environment.dart';
import 'package:lifetools/src/services/data_persistence_service/index.dart';
import 'package:lifetools/src/utils/graphql/graphql_helper.dart';

void main() async {
  // Setup developement environment
  Environment.dev();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and helpers
  await DataPersistenceService().init();
  GraphQLHelper().init();

  runApp(App());
}