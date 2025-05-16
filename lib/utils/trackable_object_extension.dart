import 'package:comscore_analytics_flutter/utils/args.dart';
import 'package:comscore_analytics_flutter/utils/trackable_object.dart';

extension TrackableObjectExtension on TrackableObject {
  Map<String, dynamic> buildArguments() {
    return <String, dynamic>{Args.refId: refId};
  }
}
