import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/widgets/widget_alert.dart';

typedef void _ChangeCallback(String newId);

class RGBModel extends StatefulWidget {
  String id;
  int r = 255;
  int g = 0;
  int b = 0;
  final _ChangeCallback? onChange;

  RGBModel(this.id, {this.onChange}) {
    var split = id.split(',');
    r = int.parse(split[1]);
    g = int.parse(split[2]);
    b = int.parse(split[3]);
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
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kOutputColor,
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Set RGB LED to color', style: kCodeBlockText),
            SizedBox(width: 10),
            GestureDetector(
              child: Container(
                height: 30,
                width: 30,
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
