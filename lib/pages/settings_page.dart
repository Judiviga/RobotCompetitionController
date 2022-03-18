import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:joystick/pages/discovery_page.dart';
import 'package:joystick/models/bluetooth_interface.dart';
import 'package:joystick/constants.dart';
import 'package:joystick/widgets/edit_alert.dart';
import 'package:joystick/models/robot_settings.dart';
import 'package:joystick/models/settings_storage.dart';
import 'package:joystick/widgets/show_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BluetoothPage extends StatefulWidget {
  static const String id = 'BluetoothPage';
  @override
  _BluetoothPage createState() => _BluetoothPage();
}

class _BluetoothPage extends State<BluetoothPage> {
  bool _enabled = false;
  StreamSubscription? listener;
  RobotSettings currentRobot = settingsList[activeSettings];

  @override
  void initState() {
    super.initState();
    listener = bluetooth.getState.listen(
      (BlueState state) {
        setState(() {
          _enabled = state.enabled;
        });
      },
    );
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    listener!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(texts.settings),
        backgroundColor: kWidgetColor,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            trailing: SizedBox(
              width: screenWidth! * 0.5,
              child: DropdownButton(
                onChanged: (int? newValue) async {
                  activeSettings = newValue!;
                  currentRobot = settingsList[activeSettings];
                  await SettingsStorage.saveActive(activeSettings);
                  setState(() {});
                },
                underline: Container(),
                dropdownColor: kWidgetColor,
                iconEnabledColor: Colors.white,
                iconSize: 40,
                isExpanded: true,
                items: settingsList
                    .map<DropdownMenuItem<int>>((RobotSettings setting) {
                  return DropdownMenuItem<int>(
                    value: int.parse(setting.id),
                    child: Text(
                      setting.name,
                      style: kTitleText,
                    ),
                  );
                }).toList(),
              ),
            ),
            title: Text(texts.profile, style: kTitleText),
          ),
          const Divider(
            color: Colors.white,
            indent: 10,
            endIndent: 10,
            thickness: 1,
            height: 2,
          ),
          ListTile(
            title: Text(texts.device, style: kTitleText),
            subtitle: Text(currentRobot.address, style: kSubtitleText),
            trailing: GestureDetector(
              child: Container(
                width: screenWidth! * 0.35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: kWidgetColor,
                ),
                child: Center(
                  child: Text(
                    texts.deviceNew,
                    style: kTitleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () async {
                future() async {
                  if (!_enabled) {
                    await FlutterBluetoothSerial.instance.requestEnable();
                  }
                }

                future().then((_) async {
                  if (_enabled) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return DiscoveryPage();
                      }),
                    ).then((value) async {
                      currentRobot = settingsList[activeSettings];
                      if (activeSettings == settingsList.length - 1) {
                        settingsList.add(
                            RobotSettings(id: settingsList.length.toString()));
                      }
                      await SettingsStorage.saveSetting(currentRobot);
                      setState(() {});
                    });
                  }
                });
              },
            ),
          ),
          Line(),
          ListTile(
            title: Text(texts.name, style: kTitleText),
            subtitle: Text(currentRobot.name, style: kSubtitleText),
            trailing: GestureDetector(
              child: Container(
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: kWidgetColor,
                ),
                child: Center(
                  child: Center(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                await editAlert(
                  context,
                  title: texts.nameEdit,
                  initialValue: currentRobot.name,
                ).then((value) async {
                  settingsList[activeSettings] =
                      settingsList[activeSettings].edit(
                    name: value,
                  );
                  currentRobot = settingsList[activeSettings];
                  if (activeSettings == settingsList.length - 1) {
                    settingsList
                        .add(RobotSettings(id: settingsList.length.toString()));
                  }
                  await SettingsStorage.saveSetting(currentRobot);
                  setState(() {});
                });
              },
            ),
          ),
          Line(),
          SwitchListTile(
            title: Text(texts.reverseL, style: kTitleText),
            inactiveTrackColor: kWidgetColor,
            activeTrackColor: Colors.greenAccent.withOpacity(0.3),
            activeColor: Colors.greenAccent,
            value: currentRobot.reverseL,
            onChanged: (bool value) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                reverseL: value,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          SwitchListTile(
            title: Text(texts.reverseR, style: kTitleText),
            inactiveTrackColor: kWidgetColor,
            activeTrackColor: Colors.greenAccent.withOpacity(0.3),
            activeColor: Colors.greenAccent,
            value: currentRobot.reverseR,
            onChanged: (bool value) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                reverseR: value,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          ValueTile(
            title: texts.speedMin,
            subtitle: currentRobot.minPWM.round().toString(),
            text: texts.speedMinMessage,
            onChange: (increment) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                minPWM: currentRobot.minPWM + increment,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          ValueTile(
            title: texts.speedMax,
            subtitle: currentRobot.maxPWM.round().toString(),
            text: texts.speedMaxMessage,
            onChange: (increment) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                maxPWM: currentRobot.maxPWM + increment,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          ValueTile(
            title: texts.accel,
            subtitle: currentRobot.maxAccel.round().toString(),
            text: texts.accelMessage,
            onChange: (increment) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                maxAccel: currentRobot.maxAccel + increment,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          ValueTile(
            increment: 0.1,
            title: texts.rotation,
            subtitle: currentRobot.turnFactor.toStringAsFixed(1),
            text: texts.rotationMessage,
            onChange: (increment) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                turnFactor: currentRobot.turnFactor + increment,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          ValueTile(
            increment: 0.01,
            title: texts.correction,
            text: texts.correctionMessage,
            subtitle: currentRobot.correction.toStringAsFixed(2),
            onChange: (increment) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                correction: currentRobot.correction + increment,
              );
              currentRobot = settingsList[activeSettings];
              if (activeSettings == settingsList.length - 1) {
                settingsList
                    .add(RobotSettings(id: settingsList.length.toString()));
              }
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),
          Line(),
          /* ValueTile(
            title: 'Send frecuency [hz]',
            subtitle: currentRobot.hz.round().toString(),
            onChange: (increment) async {
              settingsList[activeSettings] = settingsList[activeSettings].edit(
                hz: currentRobot.hz + increment,
              );
              currentRobot = settingsList[activeSettings];
              await SettingsStorage.saveSetting(currentRobot);
              setState(() {});
            },
          ),*/
          SizedBox(height: 10),
          ListTile(
            title: GestureDetector(
              child: Container(
                width: screenWidth! * 0.35,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: kWidgetColor,
                ),
                child: Center(
                  child: Text(
                    texts.reset,
                    style: kTitleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () {
                showBasicAlert(
                  context,
                  title: texts.reset,
                  message: texts.resetMessage,
                  onConfirm: () async {
                    settingsList[activeSettings] =
                        settingsList[activeSettings].reset();
                    currentRobot = settingsList[activeSettings];
                    await SettingsStorage.saveSetting(currentRobot);
                    setState(() {});
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: GestureDetector(
              child: Container(
                width: screenWidth! * 0.35,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  color: Colors.red.withOpacity(0.6),
                ),
                child: Center(
                  child: Text(
                    texts.delete,
                    style: kTitleText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            onTap: () {
              showBasicAlert(
                context,
                title: texts.delete,
                message: texts.deleteMessage,
                onConfirm: () async {
                  if (activeSettings != settingsList.length - 1) {
                    for (int i = activeSettings.toInt();
                        i < settingsList.length - 2;
                        i++) {
                      settingsList[i] = settingsList[i + 1].edit();
                      await SettingsStorage.saveSetting(settingsList[i]);
                    }
                    await SettingsStorage.deleteSetting(
                        (settingsList.length - 2).toString());
                    settingsList = await SettingsStorage.getList();
                    activeSettings = 0;
                    currentRobot = settingsList[activeSettings];
                    setState(() {});
                  }
                },
              );
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

typedef void _ValueCallback(double value);

class ValueTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String text;
  final _ValueCallback onChange;
  final double increment;

  const ValueTile({
    required this.title,
    required this.subtitle,
    required this.onChange,
    this.increment = 1,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: GestureDetector(
        child: Row(
          children: [
            Text(title, style: kTitleText),
            Container(
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: kWidgetColor,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () async {
          await showBasicAlert(
            context,
            title: title,
            message: text,
          );
        },
      ),
      subtitle: Text(
        subtitle,
        style: kSubtitleText,
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: kWidgetColor,
              ),
              child: Center(
                child: Center(
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            onTap: () {
              onChange(-increment);
            },
          ),
          VerticalDivider(
            color: Colors.white,
            thickness: 1,
            width: 35,
          ),
          GestureDetector(
            child: Container(
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: kWidgetColor,
              ),
              child: Center(
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            onTap: () {
              onChange(increment);
            },
          ),
        ],
      ),
    );
  }
}

class Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: KsubtitleColor,
      height: 1,
      thickness: 0.1,
    );
  }
}
