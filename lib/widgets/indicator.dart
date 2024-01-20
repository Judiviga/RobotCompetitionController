import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:joystick/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:joystick/models/bluetooth_interface.dart';

class Indicator extends StatefulWidget {
  final String name;
  const Indicator({required this.name});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  bool _enabled = false;
  bool _connected = false;
  StreamSubscription? listener;

  @override
  void initState() {
    listener = bluetooth.getState.listen(
      (BlueState state) {
        setState(() {
          _enabled = state.enabled;
          _connected = state.connected;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    listener!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context)!;
    Color color = Colors.grey;
    String title = texts.disabled;
    String subtitle = '';
    String state = 'OFF';

    if (!_enabled) {
      color = Colors.grey[600]!;
      title = widget.name;
      subtitle = texts.disabled;
      state = 'OFF';
    } else if (!_connected) {
      color = Colors.red;
      title = widget.name;
      subtitle = texts.disconnected;
      state = 'ON';
    } else {
      color = Colors.green;
      title = widget.name;
      subtitle = texts.connected;
      state = 'ON';
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      width: 80,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Container(
                    height: 35,
                    width: 50,
                    child: Switch(
                      splashRadius: 10,
                      activeColor: Colors.white,
                      activeTrackColor: kWidgetColor.withOpacity(0.8),
                      value: _enabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bluetooth,
                        color: Colors.white,
                      ),
                      Text(state, style: kSubtitleText),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.5,
            height: 1,
          ),
          Expanded(
            flex: 6,
            child: RotatedBox(
              quarterTurns: -1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      title,
                      style: kBotonText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(subtitle, style: kSubtitleText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
