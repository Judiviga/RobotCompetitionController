import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:joystick/widgets/color_picker.dart';

typedef void _ChangeCallback(String newId);

class RGBModel extends StatefulWidget {
  String id;
  int r = 255;
  int g = 0;
  int b = 0;
  final _ChangeCallback? onChange;

  RGBModel(this.id, {this.onChange}) {
    var split = id.split(',');
    if (split.length>1){
    r = int.parse(split[1]);
    g = int.parse(split[2]);
    b = int.parse(split[3]);
    }

  }
  void function() async {
    robot.red = r;
    robot.green = g;
    robot.blue = b;
  }

  void _changeColor(int red, int green, int blue) {
    r = red;
    g = green;
    b = blue;
    id = 'RGB,$r,$g,$b';
    if (onChange != null) {
      onChange!(id);
    }
  }

  @override
  State<RGBModel> createState() => _RGBModelState();
}

class _RGBModelState extends State<RGBModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      width: codeBlockWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kOutputColor,
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: codeBlockPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Set RGB LED to color', style: kCodeBlockText),
            SizedBox(width: 10),
            GestureDetector(
              child: Container(
                height: codeBlockButtonHeight,
                width: codeBlockButtonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, widget.r, widget.g, widget.b),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                ),
              ),
              onTap: () {
                widget.onChange != null
                    ? widgetAlert(
                        context,
                        rInitial: widget.r,
                        bInitial: widget.b,
                        gInitial: widget.g,
                        onConfirm: (int r, int g, int b) {
                          widget._changeColor(r, g, b);
                          setState(() {});
                        },
                      )
                    : {};
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
