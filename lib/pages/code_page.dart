import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/widgets/color_picker.dart';

class CodePage extends StatefulWidget {
  static const String id = 'CodePage';
  CodePage({Key? key}) : super(key: key);

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // body: ColorPicker(200),
    );
  }
}
