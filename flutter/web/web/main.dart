import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:flutter_app/main_dev.dart' as app;

main() async {
  await ui.webOnlyInitializePlatform();
  app.main();
}
