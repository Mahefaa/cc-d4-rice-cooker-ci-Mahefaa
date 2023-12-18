import 'dart:io';

import 'rice_cooker.dart';
import 'exception/custom_exception.dart';

class Runner {
  final RiceCooker cooker;
  final userInputReader = stdin;
  bool isRunning = false;

  Runner(this.cooker) {
    isRunning = false;
  }

  void run() {
    isRunning = true;

    showMenu();

    var answer = userInputReader.readLineSync();
    tryCatchLogger(() {
      final number = int.tryParse(answer ?? '');
      if (number == null) {
        throw CustomException('unknown Argument, try again');
      }
      handleChoice(number);
    }, null);
  }

  void stop() {
    isRunning = false;
    exit(0);
  }

  void showMenu() {
    showState();
    print('''
      Cooker Menu:
        1. plug a rice cooker in
        2. unplug a rice cooker
        3. increase rice amount by 1cup
        4. increase water level by 1L
        5. decrease rice amount by 1cup
        6. decrease water level by 1L
        7. cook rice (needs water)
        8. boil water ( does not need rice)
        0. Exit
        Enter your choice:
    ''');
  }

  void showState() {
    print('''
      Cooker : 
        state : ${cooker.status.powerStatus}, ${cooker.status.workStatus}
        rice level : ${cooker.riceAmount},
        water level : ${cooker.waterLevel},
        available space : ${cooker.computeAvailableSpace()}
    ''');
  }

  void handleChoice(int choice) {
    switch (choice) {
      case 1:
        finallyContinuedTryCatchLogger(() {
          cooker.plug();
        });
        break;
      case 2:
        finallyContinuedTryCatchLogger(() {
          cooker.unplug();
        });
        break;
      case 3:
        finallyContinuedTryCatchLogger(() {
          cooker.addRice();
        });
        break;
      case 4:
        finallyContinuedTryCatchLogger(() {
          cooker.addWater();
        });
        break;
      case 5:
        finallyContinuedTryCatchLogger(() {
          cooker.decreaseRiceAmount();
        });
        break;
      case 6:
        finallyContinuedTryCatchLogger(() {
          cooker.decreaseWaterLevel();
        });
        break;
      case 7:
        finallyContinuedTryCatchLogger(() {
          cooker.cook();
        });
        break;
      case 8:
        finallyContinuedTryCatchLogger(() {
          cooker.boilWater();
        });
        break;
      case 0:
        stop();
        break;
    }
  }

  void continueApp() {
    if (isRunning) {
      run();
    } else {
      print('Application closed');
      isRunning = false;
      exit(0);
    }
  }

  void finallyContinuedTryCatchLogger(void Function() tryCb) {
    tryCatchLogger(tryCb, () {
      continueApp();
    });
  }
}

void tryCatchLogger(Function tryCallback, Function? finallyCallback) {
  try {
    tryCallback();
  } catch (e) {
    print('$e');
  } finally {
    finallyCallback?.call();
  }
}