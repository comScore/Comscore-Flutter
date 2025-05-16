package com.comscore.flutter.streaming;

import static com.comscore.flutter.Args.LABELS;
import static com.comscore.flutter.Args.LABEL_NAME;
import static com.comscore.flutter.Args.LABEL_VALUE;

import androidx.annotation.NonNull;

import com.comscore.flutter.Args;
import com.comscore.flutter.ObjTracker;
import com.comscore.streaming.StreamingPublisherConfiguration;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class StreamingPublisherConfigurationMethodCallHandler implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "removeAllLabels": {
                StreamingPublisherConfiguration streamingPublisherConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingPublisherConfiguration.removeAllLabels();
                result.success(null);
                break;
            }
            case "removeLabel": {
                StreamingPublisherConfiguration streamingPublisherConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingPublisherConfiguration.removeLabel(Args.getArgValue(call.arguments, LABEL_NAME));
                result.success(null);
                break;
            }
            case "setLabel": {
                StreamingPublisherConfiguration streamingPublisherConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingPublisherConfiguration.setLabel(Args.getArgValue(call.arguments, LABEL_NAME), Args.getArgValue(call.arguments, LABEL_VALUE));
                result.success(null);
                break;
            }
            case "addLabels": {
                StreamingPublisherConfiguration streamingPublisherConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingPublisherConfiguration.addLabels(Args.getArgValue(call.arguments, LABELS));
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }
}
