import 'package:flutter/material.dart';
import 'package:joystick/models/robot_interface.dart';
import 'package:joystick/models/robot_settings.dart';

double? screenHeight;
double? screenWidth;

double codeBlockWidth = 260;
double codeBlockPadding = 5;
double codeBlockButtonHeight = 33;

Color kBackgroundColor = const Color.fromRGBO(23, 23, 23, 1);
Color kWidgetColor = const Color.fromRGBO(63, 63, 63, 1);
Color KsubtitleColor = Colors.white.withOpacity(0.5);
Color kgreyColor = const Color.fromRGBO(248, 248, 248, 1);
Color kOutputColor = Color.fromARGB(255, 42, 118, 225);
Color kVariableColor = Color.fromARGB(255, 214, 92, 214);
Color kInputColor = Color.fromARGB(255, 153, 102, 255);
Color kControlColor = Color.fromARGB(255, 255, 171, 25);
Color kMathColor = Color.fromARGB(255, 64, 191, 74);



TextStyle kScaleTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

TextStyle kBotonText = const TextStyle(
  color: Colors.white,
  fontSize: 18,
);

TextStyle kTitleText = const TextStyle(
  color: Colors.white,
  fontSize: 16,
);
TextStyle kSubtitleText = TextStyle(
  color: KsubtitleColor,
  fontSize: 16,
);
TextStyle kCodeBlockText = TextStyle(
  color: Colors.white,
  fontSize: 14,
);

List<RobotSettings> settingsList = List<RobotSettings>.empty(growable: true);
int activeSettings = 0;
Robot robot = Robot(settingsList[activeSettings]);
