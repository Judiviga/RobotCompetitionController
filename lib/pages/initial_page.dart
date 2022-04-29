import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joystick/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:joystick/pages/code_page.dart';
import 'package:joystick/pages/joystick_page.dart';
import 'package:joystick/pages/settings_page.dart';


class InitialPage extends StatefulWidget {
  static const String id = 'InitialPage';
  InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    } else {
      screenHeight = MediaQuery.of(context).size.width;
      screenWidth = MediaQuery.of(context).size.height;
    }
    AppLocalizations texts = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kWidgetColor,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(systemNavigationBarColor: Colors.red),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  width: screenWidth! * 0.35,
                  height: screenWidth! * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    ),
                    color: kWidgetColor,
                  ),
                  child: Center(child: Text('Code', style: kBotonText)),
                ),
                onTap: () {
                  Navigator.pushNamed(context, CodePage.id);
                },
              ),
              SizedBox(width: screenWidth! * 0.1),
              GestureDetector(
                child: Container(
                  width: screenWidth! * 0.35,
                  height: screenWidth! * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    ),
                    color: kWidgetColor,
                  ),
                  child: Center(child: Text('Joystick', style: kBotonText)),
                ),
                onTap: () {
                  Navigator.pushNamed(context, JoystickPage.id);
                },
              ),
            ],
          ),
          SizedBox(height: 40),
          GestureDetector(
            child: Container(
              width: screenWidth! * 0.8,
              height: screenWidth! * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: kWidgetColor,
              ),
              child: Center(child: Text('Settings', style: kBotonText)),
            ),
            onTap: () {
              Navigator.pushNamed(context, SettingsPage.id).then((value) {
                robot.updateSetting(settingsList[activeSettings]);
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}
