import 'package:joystick/constants.dart';
import 'package:flutter/material.dart';

typedef void _ValueCallback(double value);

class HorizontalJoystick extends StatefulWidget {
  final double long;
  final double thickness;
  final _ValueCallback callback;

  HorizontalJoystick({
    required this.long,
    required this.thickness,
    required this.callback,
  });
  @override
  State<HorizontalJoystick> createState() => _HorizontalJoystickState();
}

class _HorizontalJoystickState extends State<HorizontalJoystick> {
  double yStart = 0;
  double y = 0;
  double value = 0;
  double yinit = 0;
  double? offset;
  double factor = 0.9;

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
                width: widget.long,
                height: widget.thickness,
                decoration: BoxDecoration(
                  color: kWidgetColor,
                ),
              ),
              button(),
              line(),
              scale(),
            ],
          ),
        ),
      ),
    );
  }

  Positioned scale() {
    return Positioned(
      height: widget.thickness * 0.5,
      width: widget.long * factor,
      left: yStart - widget.long * factor * 0.5,
      top: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _verticalText(' 100'),
          _verticalText('  75'),
          _verticalText('  50'),
          _verticalText('  25'),
          _verticalText('   0'),
          _verticalText(' -25'),
          _verticalText(' -50'),
          _verticalText(' -75'),
          _verticalText('-100'),
        ],
      ),
    );
  }

  Positioned button() {
    return Positioned(
      bottom: 0,
      left: y - 1,
      child: Container(
        height: widget.thickness * 0.8,
        width: 2,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }

  Positioned line() {
    return Positioned(
      bottom: 0,
      left: yStart - 1,
      child: Container(
        height: widget.thickness * 0.8,
        width: 2,
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
      ),
    );
  }

  _onPan(DragUpdateDetails details) {
    setState(() {
      y = details.globalPosition.dx - offset!;
      value = (yStart - y) * 200 / (widget.long * factor);
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
    var dy = details.globalPosition.dx - offset!;
    setState(() {
      yStart = dy;
      y = yStart;
    });
  }

  RotatedBox _verticalText(String text) {
    return RotatedBox(
      quarterTurns: -1,
      child: Text(text, style: kScaleTextStyle, textAlign: TextAlign.right),
    );
  }
}
