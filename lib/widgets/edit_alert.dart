import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef void NameCallback(String value);

Future<String> editAlert(
  final BuildContext context, {
  final String? title,
  final String? message,
  final String initialValue = '',
  final NameCallback? onConfirm,
}) async {
  String name = initialValue;
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      AppLocalizations texts = AppLocalizations.of(context)!;
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
              message != null
                  ? Text(
                      message,
                      textAlign: TextAlign.center,
                      style: kSubtitleText,
                    )
                  : SizedBox(height: 0),
              TextFormField(
                autofocus: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: kSubtitleText,
                textAlign: TextAlign.center,
                initialValue: initialValue,
                onChanged: (value) {
                  name = value;
                },
              )
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return name;
}
