import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';

typedef void _ValueCallback(double value);

class VerticalJoystick extends StatefulWidget {
  final double long;
  final double thickness;
  final _ValueCallback callback;

  VerticalJoystick({
    required this.long,
    required this.thickness,
    required this.callback,
  });

  @override
  State<VerticalJoystick> createState() => _VerticalJoystickState();
}

class _VerticalJoystickState extends State<VerticalJoystick> {
  double yStart = 0;
  double y = 0;
  double value = 0;
  double? offset;
  double yinit = 0;
  double factor = 1.5;
  bool vertical = true;

  @override
  void initState() {
    yStart = widget.long * 0.5;
    y = yStart;
    yinit = yStart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    offset ??= 0;

    return GestureDetector(
      onPanStart: _onStart,
      onPanUpdate: _onPan,
      onPanEnd: _onPanEnd,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(35)),
            color: kWidgetColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 0.5,
                blurRadius: 0.5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(35)),
            child: Stack(
              children: [
                Container(
                  width: widget.thickness,
                  height: widget.long,
                  color: kWidgetColor,
                ),
                button(),
                line(),
                scale(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned scale() {
    return Positioned(
      height: widget.long * factor,
      width: widget.thickness * 0.98,
      top: yStart - widget.long * factor * 0.5,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _verticalText('-100'),
          _verticalText(' -75'),
          _verticalText(' -50'),
          _verticalText(' -25'),
          _verticalText('  0'),
          _verticalText('  25'),
          _verticalText('  50'),
          _verticalText('  75'),
          _verticalText(' 100'),
        ],
      ),
    );
  }

  Positioned button() {
    return Positioned(
      top: y - 1,
      right: 0,
      child: Container(
        height: 2,
        width: widget.thickness * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }

  Positioned line() {
    return Positioned(
      top: yStart - 1,
      right: 0,
      child: Container(
        height: 2,
        width: widget.thickness * 0.85,
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
      ),
    );
  }

  _onPan(DragUpdateDetails details) {
    setState(() {
      y = details.globalPosition.dy;
      value = -(yStart - y) * 200 / (widget.long * factor);
      if (value > 100) value = 100;
      if (value < -100) value = -100;
      widget.callback(value);
    });
  }

  _onPanEnd(DragEndDetails details) {
    setState(() {
      yStart = yinit;
      y = yStart;
      value = 0;
      widget.callback(value);
    });
  }

  _onStart(DragStartDetails details) {
    var dy = details.globalPosition.dy;
    setState(() {
      yStart = dy;
      y = yStart;
    });
  }

  RotatedBox _verticalText(String text) {
    return RotatedBox(
      quarterTurns: -1,
      child: Text(
        text,
        style: kScaleTextStyle,
        textAlign: TextAlign.left,
      ),
    );
  }
}
