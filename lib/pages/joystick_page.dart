import 'dart:async';
import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/models/bluetooth_interface.dart';
import 'package:joystick/pages/settings_page.dart';
import 'package:joystick/widgets/color_picker.dart';
import 'package:joystick/widgets/horizontal_joystick.dart';
import 'package:joystick/widgets/indicator.dart';
import 'package:joystick/widgets/vertical_joystick.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fullscreen/fullscreen.dart';

class JoystickPage extends StatefulWidget {
  static const String id = 'JoystickPage';
  @override
  State<JoystickPage> createState() => _JoystickPageState();
}

class _JoystickPageState extends State<JoystickPage> {
  int rightLong = 50;
  int leftThick = 22;
  //StreamSubscription? inputListener; //bluetooth input stream
  String input = '-';

  @override
  void initState() {
    robot.green = 255;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    /*inputListener = bluetooth.getinput.listen(
      (String i) {
        if (i != input) {
          setState(() {});
        }
        input = i;
        print(input.toString());
      },
    );*/
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: rightLong,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Indicator(
                  name: robot.settings.name,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Boton(
                    text: texts.settings,
                    onTap: () {
                      // FullScreen.exitFullScreen();
                      Navigator.pushNamed(context, SettingsPage.id)
                          .then((value) async {
                        await robot.updateSetting(settingsList[activeSettings]);
                        setState(() {});
                      });
                      // Navigator.pop(context);
                    },
                  ),
                ),
                VerticalJoystick(
                  long: screenHeight! * rightLong.toDouble() / 100,
                  thickness: screenHeight! * 0.2,
                  callback: (val) {
                    robot.rightJoystick = val;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 100 - rightLong - leftThick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                ColorPicker(
                  width: 200,
                  callback: (R, G, B) {
                    robot.red = R;
                    robot.green = G;
                    robot.blue = B;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: leftThick,
            child: HorizontalJoystick(
              long: screenWidth!,
              thickness: screenHeight! * leftThick.toDouble() / 100,
              callback: (val) {
                robot.leftJoystick = val;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CircleBoton extends StatelessWidget {
  const CircleBoton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (robot.boton == 1) {
          robot.boton = 0;
        } else {
          robot.boton = 1;
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: screenWidth! * 0.35,
            width: screenWidth! * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kWidgetColor,
              border: Border.all(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            child: RotatedBox(
              quarterTurns: -1,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Boton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const Boton({
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 40,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 0.5,
          ),
          color: kWidgetColor,
        ),
        child: RotatedBox(
          quarterTurns: -1,
          child: Center(
            child: Text(
              text,
              style: kBotonText,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
