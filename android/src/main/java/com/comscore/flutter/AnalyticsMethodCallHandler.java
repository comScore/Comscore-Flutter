package com.comscore.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.comscore.Analytics;
import com.comscore.EventInfo;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AnalyticsMethodCallHandler implements MethodCallHandler {

    private Context context;
    public void setContext(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "start":
                Analytics.start(context);
                result.success(null);
                break;
            case "getVersion":
                result.success(Analytics.getVersion());
                break;
            case "notifyViewEvent": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments, Args.EVENT_INFO_REF_ID);
                Map<String, String> labels = Args.getArgValue(call.arguments, Args.LABELS);
                if (eventInfo == null && labels != null) {
                    eventInfo = new EventInfo();
                }
                if (labels != null) {
                    eventInfo.addLabels(labels);
                }
                if (eventInfo != null) {
                    Analytics.notifyViewEvent(eventInfo);
                } else {
                    Analytics.notifyViewEvent();
                }
                result.success(null);
                break;
            }
            case "notifyHiddenEvent": {
                EventInfo eventInfo = ObjTracker.getTrackedObjFromArguments(call.arguments, Args.EVENT_INFO_REF_ID);
                Map<String, String> labels = Args.getArgValue(call.arguments, Args.LABELS);
                if (eventInfo == null && labels != null) {
                    eventInfo = new EventInfo();
                }
                if (labels != null) {
                    eventInfo.addLabels(labels);
                }
                if (eventInfo != null) {
                    Analytics.notifyHiddenEvent(eventInfo);
                } else {
                    Analytics.notifyHiddenEvent();
                }
                result.success(null);
                break;
            }
            case "notifyEnterForeground":
                Analytics.notifyEnterForeground();
                result.success(null);
                break;
            case "notifyExitForeground":
                Analytics.notifyExitForeground();
                result.success(null);
                break;
            case "notifyUxActive":
                Analytics.notifyUxActive();
                result.success(null);
                break;
            case "notifyUxInactive":
                Analytics.notifyUxInactive();
                result.success(null);
                break;
            case "flushOfflineCache":
                Analytics.flushOfflineCache();
                result.success(null);
                break;
            case "clearOfflineCache":
                Analytics.clearOfflineCache();
                result.success(null);
                break;
            case "clearInternalData":
                Analytics.clearInternalData();
                result.success(null);
                break;
            case "setLogLevel":
                Analytics.setLogLevel((Integer) call.arguments);
                result.success(null);
                break;
            case "getLogLevel":
                result.success(Analytics.getLogLevel());
                break;
            case "notifyDistributedContentViewEvent":
                String distributorPartnerId = Args.getArgValue(call.arguments, Args.DISTRIBUTOR_PARTNER_ID);
                String distributorContentId = Args.getArgValue(call.arguments, Args.DISTRIBUTOR_CONTENT_ID);
                Analytics.notifyDistributedContentViewEvent(distributorPartnerId, distributorContentId);
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
