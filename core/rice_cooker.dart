import 'exception/custom_exception.dart';

class RiceCooker {
  late Status _status;
  late int _maxSpace;
  late int _waterLevel;
  late int _riceAmount;

  static const int DEFAULT_MAX_SPACE = 10;

  RiceCooker()
      : _maxSpace = DEFAULT_MAX_SPACE,
        _waterLevel = 0,
        _riceAmount = 0,
        _status = Status(
            powerStatus: PowerStatus.OFF, workStatus: WorkStatus.AVAILABLE) {
  }

  Status get status => _status;

  int get waterLevel => _waterLevel;

  int get riceAmount => _riceAmount;

  int computeAvailableSpace() => _maxSpace - _waterLevel - _riceAmount;

  int addWater() {
    _ensureCapacity();
    print('adding 1L of water');
    return _waterLevel++;
  }

  int addRice() {
    _ensureCapacity();
    print('adding 1 cup of rice');
    return _riceAmount++;
  }

  int decreaseWaterLevel() {
    if (_waterLevel > 0) {
      return _waterLevel--;
    }
    throw CustomException('Water level is already 0');
  }

  int decreaseRiceAmount() {
    if (_riceAmount > 0) {
      print('removing 1 cup of rice');
      return _riceAmount--;
    }
    throw CustomException('Rice amount is already 0');
  }

  void _ensureCapacity() {
    final availableSpace = computeAvailableSpace();
    if (availableSpace == 0) {
      throw CustomException('Rice cooker is already full.');
    }
  }

  RiceCooker plug() {
    if (isPluggedIn()) {
      throw CustomException('Rice cooker already plugged in');
    }
    print('Plugging the rice cooker in');
    _status.powerStatus = PowerStatus.ON;
    print('Rice cooker plugged in');
    return this;
  }

  bool isPluggedIn() => _status.powerStatus == PowerStatus.ON;

  bool isBusy() => _status.workStatus == WorkStatus.BUSY;

  RiceCooker unplug() {
    if (!isPluggedIn()) {
      throw CustomException('Rice cooker already unplugged');
    }
    print('Unplugging the rice cooker');
    _status.powerStatus = PowerStatus.OFF;
    print('Rice cooker plugged out');
    return this;
  }

  static const int RICE_COOKER_COOKING_TIME = 10;

  void cook() {
    _ensureAvailability();
    ensureWaterPresence();
    ensureRicePresence();
    print('Cooking');
    _status.workStatus = WorkStatus.BUSY;
    _countFromOneUntil(RICE_COOKER_COOKING_TIME);
    print('Rice is cooked');
    _status.workStatus = WorkStatus.AVAILABLE;
  }

  void ensureWaterPresence() {
    if (_waterLevel <= 0) {
      throw CustomException('Rice Cooker needs water');
    }
  }

  void ensureRicePresence() {
    if (_riceAmount <= 0) {
      throw CustomException('Rice Cooker needs rice for this action');
    }
  }

  void _ensureAvailability() {
    if (!isPluggedIn()) {
      throw CustomException('Turn the rice cooker on first');
    }
    if (isBusy()) {
      throw CustomException('Wait for the rice cooker to be free');
    }
  }

  static const int BOILING_WATER_TIME = 8;

  void boilWater() {
    _ensureAvailability();
    ensureWaterPresence();
    print('Boiling water');
    _status.workStatus = WorkStatus.BUSY;
    _countFromOneUntil(BOILING_WATER_TIME);
    _status.workStatus = WorkStatus.AVAILABLE;
    print('Water is boiling');
  }

  void _countFromOneUntil(int duration) async {
    for (int i = 1; i <= duration; i++) {
      print(i);
    }
  }
}

class Status {
  PowerStatus powerStatus;
  WorkStatus workStatus;

  Status({required this.powerStatus, required this.workStatus});
}

enum PowerStatus {
  ON,
  OFF,
}

enum WorkStatus {
  BUSY,
  AVAILABLE,
}
