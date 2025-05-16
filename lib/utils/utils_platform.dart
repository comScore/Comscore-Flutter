import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:flutter/services.dart';

abstract class UtilsPlatform {
  static const methodChannel = MethodChannel("com.comscore.utils");

  UtilsPlatform();

  static Future<void> destroyInstance(String refId) async {
    return methodChannel.invokeMethod('destroyInstance', <String, dynamic>{Args.refId: refId});
  }
}
