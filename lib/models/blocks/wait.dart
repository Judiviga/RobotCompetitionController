import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joystick/constants.dart';

typedef void _ChangeCallback(String newId);

class WaitModel extends StatefulWidget {
  String id;
  int millis = 1000;
  String _inital = '1000';
  final _ChangeCallback? onChange;

  WaitModel(this.id, {this.onChange}) {
    var split = id.split(',');
    _inital = split[1];
    if (split.length > 1) {
      millis = int.parse(split[1]);
    }
  }
  Future<void> function() {
    return Future.delayed(Duration(milliseconds: millis), () {});
  }

  void _changeValue(String value) {
    millis = int.parse(value);
    id = 'Wait,' + value;
    if (onChange != null) {
      onChange!(id);
    }
  }

  @override
  State<WaitModel> createState() => _WaitModelState();
}

class _WaitModelState extends State<WaitModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      width: codeBlockWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kControlColor,
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
            Text('Wait', style: kCodeBlockText),
            SizedBox(width: 5),
            Container(
              height: codeBlockButtonHeight,
              width: 70,
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
                /*controller: TextEditingController(
                  text: widget.millis.toString(),
                ),*/
                initialValue: widget._inital,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: kCodeBlockText.copyWith(color: Colors.black),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
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
            SizedBox(width: 5),
            Text('milliseconds', style: kCodeBlockText),
          ],
        ),
      ),
    );
  }
}
