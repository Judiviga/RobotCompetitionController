import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showBasicAlert(
  final BuildContext context, {
  final String? title,
  final String? message,
  final Function? onConfirm,
  final String? buttonText,
}) async {
  return showDialog<void>(
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
            ],
          ),
        ),
        actions: <Widget>[
          onConfirm != null
              ? GestureDetector(
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
                        texts.cancel,
                        style: kTitleText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  })
              : SizedBox(height: 0, width: 0),
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
                color: onConfirm != null
                    ? Colors.red.withOpacity(0.6)
                    : kWidgetColor,
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
              if (onConfirm == null) {
                Navigator.of(context).pop();
              } else {
                onConfirm();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
