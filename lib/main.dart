import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joystick/pages/code_page.dart';
import 'package:joystick/pages/initial_page.dart';
import 'package:joystick/pages/settings_page.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/pages/joystick_page.dart';
import 'package:joystick/models/settings_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    WidgetsFlutterBinding.ensureInitialized();
    await SettingsStorage.init();
    settingsList = await SettingsStorage.getList();
    activeSettings = SettingsStorage.loadActive();
    // SettingsStorage.deleteSetting('1');
    //activeSettings = 0;
    runApp(Controller());
  });
}

class Controller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Pad',
      home: JoystickPage(),
      // onGenerateRoute: ,
      routes: {
        JoystickPage.id: (context) {
          return JoystickPage();
        },
        CodePage.id: (context) => CodePage(),
        SettingsPage.id: (context) => SettingsPage(),
        InitialPage.id: (context) => InitialPage(),
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kWidgetColor),
      ),
    );
  }
}
