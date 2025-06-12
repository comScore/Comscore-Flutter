import 'package:comscore_analytics_flutter/src/utils/utils_platform.dart';

abstract class TrackableObject {
  final String refId;
  static final Map<String, Finalizer<String>> _finalizers = {};

  TrackableObject(this.refId) {
    Finalizer<String> finalizer = Finalizer((refId) {
      UtilsPlatform.destroyInstance(refId);
      _finalizers.remove(refId);
    });
    finalizer.attach(this, refId);
    _finalizers[refId] = finalizer;
  }
}
