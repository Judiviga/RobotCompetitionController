import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joystick/constants.dart';

typedef void _ChangeCallback(String newId);

class DriveModel extends StatefulWidget {
  String id;
  int speed = 20;
  String _inital = '20';
  final _ChangeCallback? onChange;
  int dropdownValue = 1;

  DriveModel(this.id, {this.onChange}) {
    var split = id.split(',');
    if (split.length > 1) {
      speed = int.parse(split[1]);
      _inital = speed.abs().toString();
      if (speed >= 0) {
        dropdownValue = 1;
      } else {
        dropdownValue = -1;
      }
    }
  }
  void function() {
    robot.leftJoystick = speed.toDouble();
  }

  void _changeValue(String value) {
    speed = int.parse(value);
    id = 'Drive,' + value;
    if (onChange != null) {
      onChange!(id);
    }
  }

  @override
  State<DriveModel> createState() => _DriveModelState();
}

class _DriveModelState extends State<DriveModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      width: codeBlockWidth * 1.1,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Move robot at speed', style: kCodeBlockText),
            SizedBox(width: 5),
            Container(
              height: codeBlockButtonHeight,
              width: 37,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: widget._inital,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: kCodeBlockText.copyWith(color: Colors.black),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                expands: true,
                maxLines: null,
                readOnly: widget.onChange != null ? false : true,
                onChanged: (value) {
                  if (value.length > 0) {
                    widget._changeValue(value);
                  }
                },
              ),
            ),
            Text('%', style: kCodeBlockText),
            SizedBox(width: 5),
            Container(
              height: codeBlockButtonHeight,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: DropdownButton<int>(
                  value: widget.dropdownValue,
                  items: [
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: -1,
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                  underline: Container(),
                  dropdownColor: Colors.white,
                  onChanged: (value) {
                    widget.dropdownValue = value!;
                    widget._changeValue((widget.speed * value).toString());
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
