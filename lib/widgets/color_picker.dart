import 'package:flutter/material.dart';

typedef void _ValueCallback(int R, int G, int B);

class ColorPicker extends StatefulWidget {
  final double width;
  final _ValueCallback callback;
  ColorPicker({required this.width, required this.callback});
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 128, 0, 255),
    Color.fromARGB(255, 225, 0, 255),
    // Color.fromARGB(255, 128, 128, 128),
  ];
  double _colorSliderPosition = 90;
  Color? _currentColor;

  @override
  initState() {
    super.initState();
    _currentColor = _calculateSelectedColor(_colorSliderPosition);
  }

  _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(_colorSliderPosition);
    });
  }

  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray =
        (position / widget.width * (_colors.length - 1));
    int index = positionInColorArray.truncate();
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      _currentColor = _colors[index];
    } else {
      //calculate new color
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
                  (_colors[index + 1].red - _colors[index].red) * remainder)
              .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
                  (_colors[index + 1].green - _colors[index].green) * remainder)
              .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
                  (_colors[index + 1].blue - _colors[index].blue) * remainder)
              .round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
      widget.callback(redValue, greenValue, blueValue);
    }

    return _currentColor!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (DragStartDetails details) {
        _colorChangeHandler(details.localPosition.dx);
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        _colorChangeHandler(details.localPosition.dx);
      },
      onTapDown: (TapDownDetails details) {
        _colorChangeHandler(details.localPosition.dx);
      },
      //This outside padding makes it much easier to grab the   slider because the gesture detector has
      // the extra padding to recognize gestures inside of
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          width: widget.width,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(colors: _colors),
          ),
          child: CustomPaint(
            painter: _SliderIndicatorPainter(_colorSliderPosition),
          ),
        ),
      ),
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(position, -10),
      Offset(position, size.height + 10),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}
