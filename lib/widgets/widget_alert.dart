import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:joystick/widgets/color_picker.dart';

typedef void RGBCallback(int r, int g, int b);

Future<void> widgetAlert(
  final BuildContext context, {
  final String? title,
  final int rInitial = 0,
  final int gInitial = 0,
  final int bInitial = 0,
  required final RGBCallback onConfirm,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      AppLocalizations texts = AppLocalizations.of(context)!;
      int r = 0;
      int g = 0;
      int b = 0;
      return AlertDialog(
        backgroundColor: kWidgetColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white70,
            width: 0.5,
          ),
        ),
        title: Text(
          title ?? ' ',
          textAlign: TextAlign.center,
          style: kBotonText,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ColorPicker(
                width: 200,
                callback: (R, G, B) {
                  r = R;
                  g = G;
                  b = B;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: kWidgetColor,
              ),
              child: Center(
                child: Text(
                  texts.confirm,
                  style: kTitleText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              onConfirm(r, g, b);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
