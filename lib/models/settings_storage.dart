import 'dart:convert';
import 'package:joystick/models/robot_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveSetting(RobotSettings robotSettings) async {
    final json = jsonEncode(robotSettings.toJson());
    final id = robotSettings.id;

    await _preferences!.setString(id, json);
  }

  static Future saveActive(int value) async {
    await _preferences!.setString('active', value.toString());
  }

  static int loadActive() {
    String? active = _preferences!.getString('active');

    if (active == null) {
      return 0;
    } else {
      return int.parse(active);
    }
  }

  static RobotSettings loadSetting(String idRobotSettings) {
    final json = _preferences!.getString(idRobotSettings);

    if (json != null) {
      return RobotSettings.fromJson(jsonDecode(json));
    } else {
      return const RobotSettings();
    }
  }

  static Future deleteSetting(String id) async {
    await _preferences!.remove(id);
  }

  static  Future<List<RobotSettings>> getList() async{
    int i = 0;
    List<RobotSettings> list = List<RobotSettings>.empty(growable: true);
    Future.doWhile(() async {
      RobotSettings item = loadSetting(i.toString());

      if (item.id == i.toString()) {
        list.add(item);
        i++;
        return true;
      } else {
        return false;
      }
    }).then((value) {
      list.add(RobotSettings(id: i.toString()));
    });
    return list;
  }
}
