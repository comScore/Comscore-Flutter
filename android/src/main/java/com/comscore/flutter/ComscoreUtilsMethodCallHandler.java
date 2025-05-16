package com.comscore.flutter;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class ComscoreUtilsMethodCallHandler implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "destroyInstance":
                ObjTracker.remove(Args.getRefId(call.arguments));
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
