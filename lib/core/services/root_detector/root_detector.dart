import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

import '../../external_dependencies.dart';
import '../../protocols/protocols.dart';
import '../../types.dart';

class RootDetectorService implements RootDetector {
  @override
  AsyncAction<bool> check() async {
    try {
      return Right(await FlutterJailbreakDetection.jailbroken);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
