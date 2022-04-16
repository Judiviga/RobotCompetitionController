import 'package:flutter/material.dart';
import 'package:joystick/pages/code_page.dart';
import 'package:joystick/pages/settings_page.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/widgets/color_picker.dart';
import 'package:joystick/widgets/horizontal_joystick.dart';
import 'package:joystick/widgets/indicator.dart';
import 'package:joystick/models/robot_interface.dart';
import 'package:joystick/widgets/vertical_joystick.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoystickPage extends StatefulWidget {
  static const String id = 'JoystickPage';
  @override
  State<JoystickPage> createState() => _JoystickPageState();
}

class _JoystickPageState extends State<JoystickPage> {
  double rightLong = 0.45;
  double leftThick = 0.2;

  @override
  void initState() {
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

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: -1,
                              child: ColorPicker(
                                width: 200,
                                callback: (R, G, B) {
                                  robot.red = R;
                                  robot.green = G;
                                  robot.blue = B;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Indicator(
                                name: robot.settings.name,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 80),
                              child: Boton(
                                text: texts.settings,
                                onTap: () {
                                  /*
                                  Navigator.pushNamed(context, BluetoothPage.id)
                                      .then((value) {
                                    robot.updateSetting(
                                        settingsList[activeSettings]);
                                    setState(() {});
                                  });*/
                                  Navigator.pushNamed(context, CodePage.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      VerticalJoystick(
                        long: screenHeight! * rightLong,
                        thickness: screenHeight! * 0.2,
                        callback: (val) {
                          robot.rightJoystick = val;
                        },
                      ),
                      const Expanded(
                        child: CircleBoton(
                          text: 'A',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: HorizontalJoystick(
              long: screenWidth!,
              thickness: screenHeight! * leftThick,
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
        print('boton');
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
