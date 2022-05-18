import 'dart:async';
import 'package:joystick/models/bluetooth_interface.dart';
import 'package:joystick/models/robot_settings.dart';

enum _moveState {
  released,
  starting,
  midSpeed,
  fullSpeed,
  staticTurn,
  slowTurn,
  midTurn,
  fullTurn,
}

class Robot {
  bool blueOn = false; // bluetooth on
  bool connected = false; //robot connected

  double leftJoystick = 0; //forward/backward speed
  double rightJoystick = 0; //turn speed

  int red = 0; //led rgb output
  int green = 0; //led rgb output
  int blue = 0; //led rgb output

  double outL = 0; //Left motor output
  double outR = 0; //Right motor output

  double turnFactor = 0; //corrected turn factor
  double correction = 0;

  ///loop variables
  double L = 0;
  double R = 0;
  bool stopped = true;

  StreamSubscription? stateListener; //bluetooth state stream
  StreamSubscription? inputListener; //bluetooth input stream
  RobotSettings settings;

  Robot(this.settings) {
    turnFactor = settings.turnFactor;
    correction = settings.correction;
    stateListener = bluetooth.getState.listen(
      (BlueState state) {
        blueOn = state.enabled;
        connected = state.connected;
      },
    );
    connect(settings.address);
    int millis = 1000 ~/ settings.hz;

    Timer.periodic(Duration(milliseconds: millis), (timer) {
      drive(leftJoystick, rightJoystick);
      if (blueOn && connected) {
        output();
      }
    });
  }

  Future connect(String address) async {
    await bluetooth.connect(address);
  }

  Future disconnect() async {
    await bluetooth.disconnect();
    //stateListener!.cancel();
    // inputListener!.cancel();
  }

  void drive(double forward, double turn) {
    double y = forward * settings.maxPWM / 100;
    double x = turn * settings.maxPWM / 100;

    _moveState state = getState(y, x);
    double targetL = y - x;
    double targetR = y + x;

    if (state == _moveState.staticTurn) {
      /////////////////////////////////////////static turn
      L = targetL;
      R = targetR;
      if (x.abs() < 10) stopped = true;
      if (stopped) {
        if (x.abs() <= 10) {
          L = 0;
          R = 0;
        } else if (x.abs() < settings.minPWM) {
          L = settings.minPWM * targetL.sign;
          R = settings.minPWM * targetR.sign;
        } else {
          stopped = false;
        }
      }
    } else if (state.index <= _moveState.fullSpeed.index) {
      //////////////////////////////////////////straight
      if (targetL > 0) {
        targetL = targetL * correction;
      } else {
        targetL = targetL / correction;
      }
      if (targetR > 0) {
        targetR = targetR / correction;
      } else {
        targetR = targetR * correction;
      }

      targetR = targetR;

      if (targetR - R > settings.maxAccel) {
        R += settings.maxAccel;
      } else if (targetR - R < -settings.maxAccel) {
        R -= settings.maxAccel;
      } else {
        R = targetR;
      }

      if (targetL - L > settings.maxAccel) {
        L += settings.maxAccel;
      } else if (targetL - L < -settings.maxAccel) {
        L -= settings.maxAccel;
      } else {
        L = targetL;
      }

      if (y.abs() < 10) stopped = true;
      if (stopped) {
        if (y.abs() <= 10) {
        } else if (y.abs() < settings.minPWM) {
          L = settings.minPWM * y.sign;
          R = settings.minPWM * y.sign;
        } else {
          stopped = false;
        }
      }
    } else {
      ////////////////////////////////////////Moveturn
      if (state.index < _moveState.fullSpeed.index) {
        if (x.sign == y.sign) {
          L = y;
          R = y + x * turnFactor;
        } else {
          L = y - x * turnFactor;
          R = y;
        }
      } else {
        if (x.sign == y.sign) {
          L = y - x * turnFactor;
          R = y;
        } else {
          L = y;
          R = y + x * turnFactor;
        }
      }

      if (y.abs() < 10) stopped = true;
      if (stopped) {
        if (y.abs() <= 10) {
        } else if (y.abs() < settings.minPWM) {
          if (x.sign == y.sign) {
            L = settings.minPWM * y.sign;
            R = settings.minPWM * y.sign + x * turnFactor;
          } else {
            L = settings.minPWM * y.sign - x * turnFactor;
            R = settings.minPWM * y.sign;
          }
        } else {
          stopped = false;
        }
      }
    }

//////////////////////////////////////////////////////////

    outL = -L;
    outR = R;
    if (settings.reverseL) outL = L;
    if (settings.reverseR) outR = -R;

    if (outL.abs() > settings.maxPWM) outL = settings.maxPWM * outL.sign;
    if (outR.abs() > settings.maxPWM) outR = settings.maxPWM * outR.sign;
  }

  _moveState getState(double y, double x) {
    if (y == 0) {
      turnFactor = settings.turnFactor;
      correction = 1;
      if (x == 0) {
        return _moveState.released;
      } else {
        return _moveState.staticTurn;
      }
    } else if (y.abs() < settings.minPWM) {
      turnFactor = settings.turnFactor * 2;
      correction = settings.correction;
      if (x == 0) {
        return _moveState.starting;
      } else {
        return _moveState.slowTurn;
      }
    } else if (y.abs() < 150) {
      turnFactor = settings.turnFactor * 1.5;
      correction = settings.correction;
      if (x == 0) {
        return _moveState.midSpeed;
      } else {
        return _moveState.midTurn;
      }
    } else {
      turnFactor = settings.turnFactor * 1.2;
      correction = settings.correction;
      if (x == 0) {
        return _moveState.fullSpeed;
      } else {
        return _moveState.fullTurn;
      }
    }
  }

  void output() {
    String val1 = outR.toString();
    String val2 = outL.toString();
    String val3 = red.toString();
    String val4 = green.toString();
    String val5 = blue.toString();

    String message = val1 + ',' + val2 + ',' + val3 + ',' + val4 + ',' + val5;
    bluetooth.send(message);
  }

  Future updateSetting(RobotSettings newSettings) async {
    if (newSettings.address != settings.address) {
      await disconnect();
      await connect(newSettings.address);
    }
    settings = newSettings;
    turnFactor = settings.turnFactor;
    correction = settings.correction;
  }
}
