class RobotSettings {
  final String id;
  final String name;
  final String address;
  final double hz;
  final bool reverseL;
  final bool reverseR;
  final double minPWM;
  final double maxPWM;
  final double maxAccel;
  final double turnFactor;
  final double correction;

  const RobotSettings({
    this.id = '',
    this.name = '<New>',
    this.address = '<No Device>',
    this.hz = 20,
    this.reverseL = false, //
    this.reverseR = false, //
    this.minPWM = 60, //
    this.maxPWM = 255, //
    this.maxAccel = 25, //
    this.turnFactor = 0.30, //
    this.correction = 1,
  });

  RobotSettings edit({
    String? id,
    String? name,
    String? address,
    double? hz,
    bool? reverseL,
    bool? reverseR,
    double? minPWM,
    double? maxPWM,
    double? maxAccel,
    double? turnFactor,
    double? correction,
  }) {
    if (hz != null) {
      if (hz > 100) hz = 100;
      if (hz < 5) hz = 5;
    }
    if (minPWM != null) {
      if (minPWM < 0) minPWM = 0;
    }
    if (maxPWM != null) {
      if (maxPWM < 0) maxPWM = 0;
      if (maxPWM > 255) maxPWM = 255;
    }
    if (maxAccel != null) {
      if (maxAccel < 1) maxAccel = 1;
    }

    return RobotSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      hz: hz ?? this.hz,
      reverseL: reverseL ?? this.reverseL,
      reverseR: reverseR ?? this.reverseR,
      minPWM: minPWM ?? this.minPWM,
      maxPWM: maxPWM ?? this.maxPWM,
      maxAccel: maxAccel ?? this.maxAccel,
      turnFactor: turnFactor ?? this.turnFactor,
      correction: correction ?? this.correction,
    );
  }

  static RobotSettings fromJson(Map<String, dynamic> json) => RobotSettings(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        hz: json['hz'],
        reverseL: json['reverseL'],
        reverseR: json['reverseR'],
        minPWM: json['minPWM'],
        maxPWM: json['maxPWM'],
        maxAccel: json['maxAccel'],
        turnFactor: json['turnFactor'],
        correction: json['correction'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'hz': hz,
        'reverseL': reverseL,
        'reverseR': reverseR,
        'minPWM': minPWM,
        'maxPWM': maxPWM,
        'maxAccel': maxAccel,
        'turnFactor': turnFactor,
        'correction': correction,
      };

  RobotSettings reset() {
    return RobotSettings(
      id: this.id,
      name: this.name,
      address: this.address,
      hz: 20,
      reverseL: false,
      reverseR: false,
      minPWM: 60,
      maxPWM: 255,
      maxAccel: 25,
      turnFactor: 0.30,
      correction: 1,
    );
  }

  @override
  String toString() => name;
}
