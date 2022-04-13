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
  bool blueOn = false;
  bool connected = false;
  double leftJoystick = 0;
  double rightJoystick = 0;
  bool sending = true;

  int red = 0;
  int green = 0;
  int blue = 0;

  bool stoppedL = true;
  bool stoppedR = true;
  bool stopped = true;
  double L = 0;
  double R = 0;

  double turnFactor = 0.20;
  double correction = 0.97;

  StreamSubscription? stateListener;
  StreamSubscription? inputListener;
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
    drive(leftJoystick, rightJoystick);
  }

  Future connect(String address) async {
    await bluetooth.connect(address);
  }

  Future disconnect() async {
    sending = false;
    await bluetooth.disconnect();
    stateListener!.cancel();
    inputListener!.cancel();
  }

  void drive(double forward, double turn) {
    int millis = 1000 ~/ settings.hz;

    Timer.periodic(Duration(milliseconds: millis), (timer) {
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
        targetL = targetL * correction;
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

      double outL = L;
      double outR = R;
      if (settings.reverseL) outL = -L;
      if (settings.reverseR) outR = -R;

      if (outL.abs() > settings.maxPWM) outL = settings.maxPWM * outL.sign;
      if (outR.abs() > settings.maxPWM) outR = settings.maxPWM * outR.sign;
/*
      print(outL.round().toString() +
          '  ' +
          outR.round().toString() +
          ' ' +
          state.toString());
          */
      if (sending && blueOn && connected) {
        output(outL, outR, red, green, blue);
      }
    });
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

  void output(double outL, double outR, int r, int g, int b) {
    String val1 = outR.round().toString();
    String val2 = outL.round().toString();
    String val3 = r.toString();
    String val4 = g.toString();
    String val5 = b.toString();

    String message = val1 + ',' + val2 + ',' + val3 + ',' + val4 + ',' + val5;
    bluetooth.send(message);
  }

  void updateSetting(RobotSettings newSettings) async {
    if (newSettings.address != settings.address) {
      await connect(newSettings.address);
    }
    settings = newSettings;
    turnFactor = settings.turnFactor;
    correction = settings.correction;
  }
}
