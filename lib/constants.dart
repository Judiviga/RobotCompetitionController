import 'package:flutter/material.dart';
import 'package:joystick/models/robot_settings.dart';

double? screenHeight;
double? screenWidth;

Color kBackgroundColor = const Color.fromRGBO(23, 23, 23, 1);
Color kWidgetColor = const Color.fromRGBO(63, 63, 63, 1);
Color KsubtitleColor = Colors.white.withOpacity(0.5);
Color kgreyColor = const Color.fromRGBO(248, 248, 248, 1);

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

List<RobotSettings> settingsList = List<RobotSettings>.empty(growable: true);
int activeSettings = 0;
