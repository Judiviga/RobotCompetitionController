import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';

class WaitModel {
  String id;
  int millis = 0;

  WaitModel(this.id) {
    var split = id.split(',');
    millis = int.parse(split[1]);
  }

  Future<void> function() {
    return Future.delayed(Duration(milliseconds: millis), () {});
  }

  Widget block() {
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
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Color.fromARGB(255, r, g, b),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
