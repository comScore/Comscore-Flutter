package com.comscore.flutter.streaming;

import static com.comscore.flutter.Args.LABELS;
import static com.comscore.flutter.Args.RATE;

import androidx.annotation.NonNull;

import com.comscore.flutter.Args;
import com.comscore.flutter.ObjTracker;
import com.comscore.streaming.StreamingExtendedAnalytics;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class StreamingExtendedAnalyticsMethodCallHandler implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "notifyLoad": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifyLoad(labels);
                result.success(null);
                break;
            }
            case "notifyEngage": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifyEngage(labels);
                result.success(null);
                break;
            }
            case "notifySkipAd": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifySkipAd(labels);
                result.success(null);
                break;
            }
            case "notifyCallToAction": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifyCallToAction(labels);
                result.success(null);
                break;
            }
            case "notifyError": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String error = Args.getArgValue(call.arguments, "error");
                streamingExtendedAnalytics.notifyError(error, labels);
                result.success(null);
                break;
            }
            case "notifyTransferPlayback": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String targetDevice = Args.getArgValue(call.arguments, "targetDevice");
                streamingExtendedAnalytics.notifyTransferPlayback(targetDevice, labels);
                result.success(null);
                break;
            }
            case "notifyDrmFail": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifyDrmFail(labels);
                result.success(null);
                break;
            }
            case "notifyDrmApprove": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifyDrmApprove(labels);
                result.success(null);
                break;
            }
            case "notifyDrmDeny": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                streamingExtendedAnalytics.notifyDrmDeny(labels);
                result.success(null);
                break;
            }
            case "notifyChangeBitrate": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                Integer rate = Args.getArgValue(call.arguments, RATE);
                streamingExtendedAnalytics.notifyChangeBitrate(rate, labels);
                result.success(null);
                break;
            }
            case "notifyChangeWindowState": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                Integer newState = Args.getArgValue(call.arguments, "newState");
                streamingExtendedAnalytics.notifyChangeWindowState(newState, labels);
                result.success(null);
                break;
            }
            case "notifyChangeAudioTrack": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String newAudio = Args.getArgValue(call.arguments, "newAudio");
                streamingExtendedAnalytics.notifyChangeAudioTrack(newAudio, labels);
                result.success(null);
                break;
            }
            case "notifyChangeVideoTrack": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String newVideo = Args.getArgValue(call.arguments, "newVideo");
                streamingExtendedAnalytics.notifyChangeVideoTrack(newVideo, labels);
                result.success(null);
                break;
            }
            case "notifyChangeSubtitleTrack": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String newSubtitle = Args.getArgValue(call.arguments, "newSubtitle");
                streamingExtendedAnalytics.notifyChangeSubtitleTrack(newSubtitle, labels);
                result.success(null);
                break;
            }
            case "notifyCustomEvent": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String eventName = Args.getArgValue(call.arguments, "eventName");
                streamingExtendedAnalytics.notifyCustomEvent(eventName, labels);
                result.success(null);
                break;
            }
            case "setPlaybackSessionExpectedLength": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Integer expectedTotalLength = Args.getArgValue(call.arguments, "expectedTotalLength");
                streamingExtendedAnalytics.setPlaybackSessionExpectedLength(expectedTotalLength);
                result.success(null);
                break;
            }
            case "setPlaybackSessionExpectedNumberOfItems": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Integer expectedNumberOfItems = Args.getArgValue(call.arguments, "expectedNumberOfItems");
                streamingExtendedAnalytics.setPlaybackSessionExpectedNumberOfItems(expectedNumberOfItems);
                result.success(null);
                break;
            }
            case "notifyChangeVolume": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                Double newVolume = Args.getArgValue(call.arguments, "newVolume");
                streamingExtendedAnalytics.notifyChangeVolume(newVolume.floatValue(), labels);
                result.success(null);
                break;
            }
            case "notifyChangeCdn": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Map<String, String> labels = Args.getArgValue(call.arguments, LABELS);
                String newCDN = Args.getArgValue(call.arguments, "newCDN");
                streamingExtendedAnalytics.notifyChangeCdn(newCDN, labels);
                result.success(null);
                break;
            }
            case "setLoadTimeOffset": {
                StreamingExtendedAnalytics streamingExtendedAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                Integer offset = Args.getArgValue(call.arguments, "offset");
                streamingExtendedAnalytics.setLoadTimeOffset(offset);
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }
}
