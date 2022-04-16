import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/models/blocks/rgb.dart';
import 'package:joystick/models/robot_interface.dart';
import 'package:joystick/widgets/indicator.dart';

List<String> _codeLines = [''];
bool _dragging = false;
bool _trashOn = false;

class DragData {
  int index;
  String id;
  DragData({required this.index, required this.id});
}

class CodePage extends StatefulWidget {
  static const String id = 'CodePage';
  CodePage({Key? key}) : super(key: key);

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  double bottomSheetSize = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottomSheetSize = screenHeight! * 0.25;
    if (_codeLines.length == 1) {
      _dragging = true;
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kWidgetColor,
      ),
      bottomSheet: Container(
        height: bottomSheetSize,
        decoration: BoxDecoration(
          color: kWidgetColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15.0,
                offset: Offset(0.0, -0.75))
          ],
        ),
        child: !_trashOn
            ? Row(
                children: [
                  Draggable<DragData>(
                    feedback: Material(
                      color: Colors.transparent,
                      child: RGBModel('RGB,255,0,0'),
                    ),
                    child: RGBModel('RGB,255,0,0'),
                    maxSimultaneousDrags: 1,
                    data: DragData(id: 'RGB,255,0,0', index: -1),
                    onDragStarted: () {
                      _dragging = true;
                      setState(() {});
                    },
                    onDragEnd: (e) {
                      _dragging = false;
                      setState(() {});
                    },
                  ),
                ],
              )
            : DragTarget<DragData>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return Container();
                },
                onAccept: (DragData incoming) {
                  _codeLines.removeAt(incoming.index);
                  if (_codeLines.length == 0) {
                    _codeLines.add('');
                  }
                  setState(() {});
                },
              ),
      ),
      floatingActionButton: Align(
        alignment: Alignment(1, 0.47),
        child: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.green,
          onPressed: () {
            //loop();
            setState(() {});
            print(_codeLines);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomSheetSize),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*Boton(
                    onTap: () {
                      functionsList.add(() {
                        Code.setColor(0, 0, 255);
                      });
                    },
                    text: 'B',
                  ),*/
                  Center(
                    child: Column(children: [
                      for (int i = 0; i < _codeLines.length; i++)
                        buildOutputTarget(i),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Function> functionsList = List<Function>.empty(growable: true);

  void loop() {
    print(functionsList);
    Future.forEach(functionsList, (Function step) async {
      await step();
    });
  }

  DragTarget<DragData> buildOutputTarget(int index) {
    return DragTarget<DragData>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        Widget widget = buildBlock(index);
        return Draggable<DragData>(
          onDragStarted: () {
            _dragging = true;
            _trashOn = true;
            setState(() {});
          },
          onDragEnd: (e) {
            _trashOn = false;
            _dragging = false;
            setState(() {});
          },
          onDragCompleted: () {
            /*
            _codeLines.removeAt(index);
            if (_codeLines.length == 2) {
              _codeLines.removeLast();
            }
            setState(() {});
            */
          },
          childWhenDragging: Container(
            height: 52,
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kWidgetColor.withOpacity(0.4),
            ),
          ),
          feedback: Material(
            color: Colors.transparent,
            child: widget,
          ),
          child: widget,
          data: DragData(id: _codeLines[index], index: index),
          maxSimultaneousDrags: _codeLines[index].isEmpty ? 0 : 1,
        );
      },
      onWillAccept: (DragData? incoming) {
        if (incoming!.id == _codeLines[index]) {
          return false;
        } else if (incoming.id == '') {
          return false;
        } else {
          return true;
        }
      },
      onAccept: (DragData incoming) {
        List<String> initial = List.from(_codeLines);
        _codeLines[index ] = incoming.id;
        if (incoming.index >= 0) {
          if (incoming.index > index) {
            for (int i = index + 1; i <= incoming.index; i++) {
              _codeLines[i] = initial[i - 1];
            }
          } else {
            for (int i = incoming.index; i < index; i++) {
              _codeLines[i] = initial[i + 1];
            }
            if (index == _codeLines.length - 1) {
              _codeLines[index - 1] = incoming.id;
              _codeLines[index] = initial[index];
            }
          }
        } else {
          for (int i = index + 1; i < _codeLines.length; i++) {
            _codeLines[i] = initial[i - 1];
          }
          _codeLines.add('');
        }
        setState(() {});
      },
    );
  }

  Widget buildBlock(int index) {
    String id = _codeLines[index];
    var type = id.split(',')[0];
    if (type == 'RGB') {
      return RGBModel(
        id,
        onChange: (newId) {
          _codeLines[index] = newId;
          setState(() {});
        },
      );
    } else {
      return EmptyOutputBlock();
    }
  }
}

class EmptyOutputBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _dragging ? kWidgetColor.withOpacity(0.4) : Colors.transparent,
      ),
    );
  }
}

class Code {
  static Future<void> wait(int millis) {
    return Future.delayed(Duration(milliseconds: millis), () {});
  }

  static void setColor(int r, int g, int b) async {
    robot.red = r;
    robot.green = g;
    robot.blue = b;
  }

  static void test(String a) async {
    print(a);
  }
}

class Boton extends StatelessWidget {
  final Function onTap;
  final String text;

  Boton({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: screenWidth! * 0.35,
            width: screenWidth! * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kWidgetColor,
              border: Border.all(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            child: RotatedBox(
              quarterTurns: -1,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
