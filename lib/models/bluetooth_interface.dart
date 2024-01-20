import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BlueState {
  final bool connected;
  final bool enabled;

  BlueState(this.connected, this.enabled);
}

class Bluetooth {
  String? address; //String address = '7C:9E:BD:60:DA:82';
  BluetoothConnection? connection;
  bool _connected = false;
  bool _enabled = false;
  bool _connecting = false;
  String? device;
  StreamController<BlueState> stateBroadcast = StreamController.broadcast();
  StreamController<String> inputBroadcast = StreamController.broadcast();

  Bluetooth() {
    _connected = connection?.isConnected ?? false;

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      _enabled = state.isEnabled;
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      print(state);
      _enabled = state.isEnabled;
    });

    loop();
  }

  Stream<BlueState> get getState => stateBroadcast.stream;
  Stream<String> get getinput => inputBroadcast.stream;

  Future<void> connect(String ad) async {
    _connecting = true;
    address = ad;
  }

  Future<void> loop() async {
    Future.doWhile(() async {
      if (!_connected && _enabled && _connecting) {
        try {
          connection = await BluetoothConnection.toAddress(address);
          print('Connected to the device');
          connection!.input!.listen((Uint8List data) {
            String raw = ascii.decode(data);
            /*var split = raw.split(',');
            List<int> inputList = List<int>.empty(growable: true);
            for (String value in split) {
              inputList.add(int.parse(value));
            }*/
            inputBroadcast.add(raw);
          }).onDone(() {
            print('Disconnected by remote request');
          });
        } catch (exception) {}
      }
      await Future.delayed(const Duration(seconds: 5));
      return true;
    });

    Future.doWhile(() async {
      _connected = connection?.isConnected ?? false;
      stateBroadcast.add(BlueState(_connected, _enabled));
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    });
  }

  Future<void> disconnect() async {
    _connecting = false;
    if (_connected && _enabled) {
      connection?.dispose();
      _connected = false;
    }
  }

  void send(String message) async {
    if (_connected && _enabled) {
      try {
        //print(message);
        connection!.output.add(Uint8List.fromList(utf8.encode(message + '\n')));
      } catch (e) {
        connection?.dispose();
        print(e);
      }
    }
  }
}

final Bluetooth bluetooth = Bluetooth();
