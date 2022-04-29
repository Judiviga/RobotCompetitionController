import 'package:flutter/material.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/models/blocks/drive.dart';
import 'package:joystick/models/blocks/rgb.dart';
import 'package:joystick/models/blocks/turn.dart';
import 'package:joystick/models/blocks/wait.dart';
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
  final ScrollController _bottomController = ScrollController();
  final ScrollController _mainController = ScrollController();
  int draggingTo = -1;
  bool running = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottomSheetSize = screenHeight! * 0.25;
    if (_codeLines.length == 1) {
      _dragging = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kWidgetColor,
        title: Text('Code'),
      ),
      bottomSheet: Container(
        height: bottomSheetSize,
        decoration: BoxDecoration(
          color: kWidgetColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15.0,
              offset: Offset(0.0, -0.75),
            )
          ],
        ),
        child: !_trashOn
            ? Scrollbar(
                controller: _bottomController,
                isAlwaysShown: true,
                radius: Radius.circular(15 / 2),
                child: SingleChildScrollView(
                  controller: _bottomController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      buildNewBlock('RGB,255,0,0'),
                      SizedBox(width: 10),
                      buildNewBlock('Wait,1000'),
                      SizedBox(width: 10),
                      buildNewBlock('Drive,20'),
                      SizedBox(width: 10),
                      buildNewBlock('Turn,20'),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              )
            : DragTarget<DragData>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return Container(
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          size: 90,
                          color: Color.fromARGB(255, 200, 1, 1),
                        ),
                        Text('Delete', style: kBotonText)
                      ],
                    ),
                  );
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
        child: !running
            ? FloatingActionButton(
                child: Icon(Icons.play_arrow),
                backgroundColor: Colors.green,
                onPressed: () {
                  loop();
                },
              )
            : FloatingActionButton(
                child: Icon(Icons.stop),
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  stop();
                },
              ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomSheetSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RotatedBox(
                quarterTurns: 1, child: Indicator(name: robot.settings.name)),
            Expanded(
              child: Center(
                child: Scrollbar(
                  controller: _mainController,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: _mainController,
                    primary: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < _codeLines.length; i++)
                                    buildOutputTarget(i),
                                ],
                              )*/
                              ListView.builder(
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _codeLines.length,
                                itemBuilder: (BuildContext context, int i) {
                                  if (i == draggingTo) {
                                    return Column(
                                      children: [
                                        Divider(
                                          height: 5,
                                          thickness: 5,
                                          color: kBackgroundColor,
                                        ),
                                        buildOutputTarget(i),
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      buildOutputTarget(i),
                                    ],
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Function> functionsList() {
    List<Function> list = List<Function>.empty(growable: true);
    for (String id in _codeLines) {
      list.add(codeFunctions(id));
    }
    return list;
  }

  void loop() {
    running = true;
    setState(() {});
    List<Function> code = functionsList();
    Future.forEach(code, (Function step) async {
      if (running) {
        await step();
      } else {
        return true;
      }
    }).then((value) {
      running = false;
      setState(() {});
    });
  }

  void stop() {
    running = false;
    setState(() {});
    DriveModel('Drive,0').function();
    TurnModel('Turn,0').function();
  }

  DragTarget<DragData> buildOutputTarget(int index) {
    return DragTarget<DragData>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        Widget widget =
            buildBlock(DragData(index: index, id: _codeLines[index]));
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
      onMove: (DragTargetDetails data) {
        int incoming = data.data.index;
        
        if (data.data.index > 0) {
          if (data.data.index < index) {
            draggingTo = index;
          } else {
            draggingTo = index + 1;
          }
        } else if (index == _codeLines.length) {
        } else {
          draggingTo = index;
        }

        setState(() {});
      },
      onLeave: (data) {
        draggingTo = -1;
        setState(() {});
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
        _codeLines[index] = incoming.id;
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
        if (index == initial.length - 1) {
          _mainController.jumpTo(
            _mainController.position.maxScrollExtent,
          );
        }
        draggingTo = -1;
        setState(() {});
      },
    );
  }

  Widget buildBlock(DragData data) {
    String id = data.id;
    String type = id.split(',')[0];
    if (type == 'RGB') {
      return RGBModel(
        data.id,
        onChange: data.index >= 0
            ? (newId) {
                _codeLines[data.index] = newId;
                setState(() {});
              }
            : null,
      );
    } else if (type == 'Wait') {
      return WaitModel(
        id,
        onChange: data.index >= 0
            ? (newId) {
                _codeLines[data.index] = newId;
                setState(() {});
              }
            : null,
      );
    } else if (type == 'Drive') {
      return DriveModel(
        id,
        onChange: data.index >= 0
            ? (newId) {
                _codeLines[data.index] = newId;
                setState(() {});
              }
            : null,
      );
    } else if (type == 'Turn') {
      return TurnModel(
        id,
        onChange: data.index >= 0
            ? (newId) {
                _codeLines[data.index] = newId;
                setState(() {});
              }
            : null,
      );
    } else {
      return EmptyOutputBlock();
    }
  }

  Widget buildNewBlock(String id) {
    return Draggable<DragData>(
      feedback: Material(
        color: Colors.transparent,
        child: buildBlock(DragData(index: -1, id: id)),
      ),
      child: buildBlock(DragData(index: -1, id: id)),
      maxSimultaneousDrags: 1,
      data: DragData(id: id, index: -1),
      onDragStarted: () {
        _dragging = true;
        setState(() {});
      },
      onDragEnd: (e) {
        _dragging = false;
        setState(() {});
      },
    );
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

Function codeFunctions(String id) {
  var type = id.split(',')[0];

  if (type == 'RGB') {
    return () {
      RGBModel(id).function();
    };
  } else if (type == 'Wait') {
    return () async {
      await WaitModel(id).function();
    };
  } else if (type == 'Drive') {
    return () {
      DriveModel(id).function();
    };
  } else if (type == 'Turn') {
    return () {
      TurnModel(id).function();
    };
  } else {
    return () {};
  }
}
