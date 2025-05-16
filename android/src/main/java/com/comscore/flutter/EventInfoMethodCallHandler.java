package com.comscore.flutter;

import static com.comscore.flutter.Args.LABELS;
import static com.comscore.flutter.Args.LABEL_NAME;
import static com.comscore.flutter.Args.LABEL_VALUE;
import static com.comscore.flutter.Args.PUBLISHER_ID;

import androidx.annotation.NonNull;

import com.comscore.EventInfo;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class EventInfoMethodCallHandler implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "newInstance":
                result.success(ObjTracker.trackObj(new EventInfo()));
                break;
            case "addLabels": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments);
                eventInfo.addLabels(Args.getArgValue(call.arguments, LABELS));
                result.success(null);
                break;
            }
            case "setLabel": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments);
                eventInfo.setLabel(Args.getArgValue(call.arguments, LABEL_NAME), Args.getArgValue(call.arguments, LABEL_VALUE));
                result.success(null);
                break;
            }
            case "addPublisherLabels": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments);
                eventInfo.addPublisherLabels(Args.getArgValue(call.arguments, PUBLISHER_ID), Args.getArgValue(call.arguments, LABELS));
                result.success(null);
                break;
            }
            case "setPublisherLabel": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments);
                eventInfo.setPublisherLabel(Args.getArgValue(call.arguments, PUBLISHER_ID), Args.getArgValue(call.arguments, LABEL_NAME), Args.getArgValue(call.arguments, LABEL_VALUE));
                result.success(null);
                break;
            }
            case "addIncludedPublisher": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments);
                eventInfo.addIncludedPublisher(Args.getArgValue(call.arguments, PUBLISHER_ID));
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }
}
