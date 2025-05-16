package com.comscore.flutter.streaming;

import static com.comscore.flutter.Args.LABELS;
import static com.comscore.flutter.Args.LABEL_NAME;
import static com.comscore.flutter.Args.LABEL_VALUE;
import static com.comscore.flutter.Args.PUBLISHER_ID;

import androidx.annotation.NonNull;

import com.comscore.flutter.Args;
import com.comscore.flutter.ObjTracker;
import com.comscore.streaming.StreamingConfiguration;
import com.comscore.streaming.StreamingPublisherConfiguration;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class StreamingConfigurationMethodCallHandler implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "removeAllLabels": {
                StreamingConfiguration streamingConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingConfiguration.removeAllLabels();
                result.success(null);
                break;
            }
            case "removeLabel": {
                StreamingConfiguration streamingConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingConfiguration.removeLabel(Args.getArgValue(call.arguments, LABEL_NAME));
                result.success(null);
                break;
            }
            case "setLabel": {
                StreamingConfiguration streamingConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingConfiguration.setLabel(Args.getArgValue(call.arguments, LABEL_NAME), Args.getArgValue(call.arguments, LABEL_VALUE));
                result.success(null);
                break;
            }
            case "addLabels": {
                StreamingConfiguration streamingConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingConfiguration.addLabels(Args.getArgValue(call.arguments, LABELS));
                result.success(null);
                break;
            }
            case "getStreamingPublisherConfiguration": {
                StreamingConfiguration streamingConfiguration = ObjTracker.getTrackedObjFromArguments(call.arguments);
                StreamingPublisherConfiguration pubConfig = streamingConfiguration.getStreamingPublisherConfiguration(Args.getArgValue(call.arguments, PUBLISHER_ID));
                result.success(ObjTracker.trackObj(pubConfig));
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }
}
