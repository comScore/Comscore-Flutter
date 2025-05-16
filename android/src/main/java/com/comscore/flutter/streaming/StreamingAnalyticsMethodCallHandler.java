package com.comscore.flutter.streaming;

import static com.comscore.flutter.Args.LABELS;
import static com.comscore.flutter.Args.POSITION;
import static com.comscore.flutter.Args.RATE;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.comscore.flutter.Args;
import com.comscore.flutter.ObjTracker;
import com.comscore.streaming.AdvertisementMetadata;
import com.comscore.streaming.AssetMetadata;
import com.comscore.streaming.ContentMetadata;
import com.comscore.streaming.StackedAdvertisementMetadata;
import com.comscore.streaming.StackedContentMetadata;
import com.comscore.streaming.StreamingAnalytics;
import com.comscore.streaming.StreamingConfiguration;
import com.comscore.streaming.StreamingListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class StreamingAnalyticsMethodCallHandler implements MethodCallHandler {
    private EventChannel eventChannelStreamingStateChanged;
    private EventChannel.EventSink attachEvent;
    private final Object lock = new Object();
    private final Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    private final List<Map<String, Object>> pendingOnStreamingStateChanged = new ArrayList<>();
    private final Map<String,StreamingAnalyticsMethodCallHandler.FlutterOnStreamingStateChangeListener> flutterOnStreamingStateChangeListeners = new HashMap<>();

    public void setBinaryMessenger(BinaryMessenger binaryMessenger) {
        this.eventChannelStreamingStateChanged = new EventChannel(binaryMessenger, "com.comscore.streaming.streamingAnalytics_OnStreamingStateChange_channel");
        eventChannelStreamingStateChanged.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                synchronized (lock) {
                    attachEvent = events;
                }
                mainThreadHandler.post(() -> {
                    for (Map<String, Object> pending : pendingOnStreamingStateChanged) {
                        attachEvent.success(pending);
                    }
                    pendingOnStreamingStateChanged.clear();
                });
            }

            @Override
            public void onCancel(Object arguments) {
                for (Map.Entry<String, StreamingAnalyticsMethodCallHandler.FlutterOnStreamingStateChangeListener> entry : flutterOnStreamingStateChangeListeners.entrySet()) {
                    StreamingAnalytics streamingAnalytics = ObjTracker.get(entry.getKey());
                    if (streamingAnalytics != null) {
                        streamingAnalytics.removeListener(entry.getValue());
                    }
                }
                attachEvent = null;
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "newInstance": {
                StreamingConfiguration.Builder builder = new StreamingConfiguration.Builder();

                Args.setIfPresent(call.arguments, LABELS, builder::labels);
                Args.setIfPresent(call.arguments, "pauseOnBuffering", builder::pauseOnBuffering);
                Args.setLongIfPresent(call.arguments, "pauseOnBufferingInterval", builder::pauseOnBufferingInterval);
                Args.setLongIfPresent(call.arguments, "keepAliveInterval", builder::keepAliveInterval);
                Args.setIfPresent(call.arguments, "keepAliveMeasurement", builder::keepAliveMeasurement);
                Args.setIfPresent(call.arguments, "heartbeatMeasurement", builder::heartbeatMeasurement);
                Args.setLongIfPresent(call.arguments, "customStartMinimumPlayback", builder::customStartMinimumPlayback);
                Args.setIfPresent(call.arguments, "autoResumeStateOnAssetChange", builder::autoResumeStateOnAssetChange);

                List<String> includedPublishers = Args.getArgValue(call.arguments, "includedPublishers");
                if (includedPublishers != null) {
                    builder.includedPublishers(includedPublishers);
                }

                List<Map<String, Integer>> rawHeartbeatIntervals = Args.getArgValue(call.arguments, "heartbeatIntervals");
                if (rawHeartbeatIntervals != null) {
                    List<Map<String, Long>> heartbeatIntervals = new ArrayList<>();
                    for (Map<String, Integer> interval : rawHeartbeatIntervals) {
                        HashMap<String, Long> heartbeat = new HashMap<String, Long>();
                        for (Map.Entry<String, Integer> entry : interval.entrySet()) {
                            heartbeat.put(entry.getKey(), entry.getValue().longValue());
                        }
                        heartbeatIntervals.add(heartbeat);
                    }
                    builder.heartbeatIntervals(heartbeatIntervals);
                }

                StreamingAnalytics streamingAnalytics = new StreamingAnalytics(builder.build());
                String streamingAnalyticsRefId = ObjTracker.trackObj(streamingAnalytics);
                String streamingConfigurationRefId = ObjTracker.trackObj(streamingAnalytics.getConfiguration());
                Map<String, String> refMap = new HashMap<>();
                refMap.put("streamingAnalyticsRefId", streamingAnalyticsRefId);
                refMap.put("streamingConfigurationRefId", streamingConfigurationRefId);
                result.success(refMap);
                break;
            }
            case "addListener": {
                String refId = Args.getRefId(call.arguments);
                FlutterOnStreamingStateChangeListener listener = flutterOnStreamingStateChangeListeners.get(refId);
                if (listener == null) {
                    StreamingAnalytics streamingAnalytics = ObjTracker.get(refId);
                    listener = new FlutterOnStreamingStateChangeListener(refId);
                    flutterOnStreamingStateChangeListeners.put(refId, listener);
                    streamingAnalytics.addListener(listener);
                }
                result.success(null);
                break;
            }
            case "removeListener": {
                String refId = Args.getRefId(call.arguments);
                StreamingAnalytics streamingAnalytics = ObjTracker.get(refId);
                FlutterOnStreamingStateChangeListener listener = flutterOnStreamingStateChangeListeners.get(refId);
                if (listener != null) {
                    streamingAnalytics.removeListener(listener);
                }
                result.success(null);
                break;
            }
            case "getExtendedAnalytics": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(ObjTracker.trackObj(streamingAnalytics.getExtendedAnalytics()));
                break;
            }
            case "createPlaybackSession": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.createPlaybackSession();
                result.success(null);
                break;
            }
            case "startFromPosition": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.startFromPosition(((Integer)Args.getArgValue(call.arguments, POSITION)).longValue());
                result.success(null);
                break;
            }
            case "notifyPlay": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifyPlay();
                result.success(null);
                break;
            }
            case "notifyPause": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifyPause();
                result.success(null);
                break;
            }
            case "notifyEnd": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifyEnd();
                result.success(null);
                break;
            }
            case "notifyBufferStart": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifyBufferStart();
                result.success(null);
                break;
            }
            case "notifyBufferStop": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifyBufferStop();
                result.success(null);
                break;
            }
            case "notifySeekStart": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifySeekStart();
                result.success(null);
                break;
            }
            case "notifyChangePlaybackRate": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.notifyChangePlaybackRate(((Double)Args.getArgValue(call.arguments, RATE)).floatValue());
                result.success(null);
                break;
            }
            case "setDvrWindowLength": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.setDvrWindowLength(((Integer) Args.getArgValue(call.arguments, Args.DVR_WINDOW)).longValue());
                result.success(null);
                break;
            }
            case "startFromDvrWindowOffset": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.startFromDvrWindowOffset(((Integer) Args.getArgValue(call.arguments, Args.DVR_WINDOW)).longValue());
                result.success(null);
                break;
            }
            case "setMediaPlayerName": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.setMediaPlayerName(Args.getArgValue(call.arguments, Args.MEDIA_PLAYER_NAME));
                result.success(null);
                break;
            }
            case "setMediaPlayerVersion": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.setMediaPlayerName(Args.getArgValue(call.arguments, Args.MEDIA_PLAYER_VERSION));
                result.success(null);
                break;
            }
            case "setMetadata": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.setMetadata(buildAssetMetadata(Args.getArgValue(call.arguments, Args.METADATA)));
                result.success(null);
                break;
            }
            case "setImplementationId": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.setImplementationId(Args.getArgValue(call.arguments, Args.IMPLEMENTATION_ID));
                result.success(null);
                break;
            }
            case "setProjectId": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.setProjectId(Args.getArgValue(call.arguments, Args.PROJECT_ID));
                result.success(null);
                break;
            }
            case "getPlaybackSessionId": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(streamingAnalytics.getPlaybackSessionId());
                break;
            }
            case "startFromSegment": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.startFromSegment(Args.getArgValue(call.arguments, Args.SEGMENT_NUMBER));
                result.success(null);
                break;
            }
            case "loopPlaybackSession": {
                StreamingAnalytics streamingAnalytics = ObjTracker.getTrackedObjFromArguments(call.arguments);
                streamingAnalytics.loopPlaybackSession();
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    StackedContentMetadata buildStackedContentMetadata(Object data) {
        StackedContentMetadata.Builder builder = new StackedContentMetadata.Builder();
        Map<String, String> labels = Args.getArgValue(data, "labels");
        if (labels != null && !labels.isEmpty()) {
            builder.customLabels(labels);
        }
        Args.setIfPresent(data, "uniqueId", builder::uniqueId);
        Args.setIfPresent(data, "programTitle", builder::programTitle);
        Args.setIfPresent(data, "episodeTitle", builder::episodeTitle);
        Args.setIfPresent(data, "episodeSeasonNumber", builder::episodeSeasonNumber);
        Args.setIfPresent(data, "episodeNumber", builder::episodeNumber);
        Args.setIfPresent(data, "genreName", builder::genreName);
        Args.setIfPresent(data, "genreId", builder::genreId);
        Args.setDateIfPresent(data, "productionDate", builder::dateOfProduction);
        Args.setTimeIfPresent(data, "productionTime", builder::timeOfProduction);
        Args.setDateIfPresent(data, "digitalAiringDate", builder::dateOfDigitalAiring);
        Args.setTimeIfPresent(data, "digitalAiringTime", builder::timeOfDigitalAiring);
        Args.setDateIfPresent(data, "tvAiringDate", builder::dateOfTvAiring);
        Args.setTimeIfPresent(data, "tvAiringTime", builder::timeOfTvAiring);
        Args.setIfPresent(data, "stationTitle", builder::stationTitle);
        Args.setIfPresent(data, "stationCode", builder::stationCode);
        Args.setIfPresent(data, "programId", builder::programId);
        Args.setIfPresent(data, "episodeId", builder::episodeId);
        Args.setIfPresent(data, "networkAffiliate", builder::networkAffiliate);
        Args.setIfPresent(data, "fee", builder::fee);
        Args.setIfPresent(data, "playlistTitle", builder::playlistTitle);
        Args.setIfPresent(data, "dictionaryClassificationC3", builder::dictionaryClassificationC3);
        Args.setIfPresent(data, "dictionaryClassificationC4", builder::dictionaryClassificationC4);
        Args.setIfPresent(data, "dictionaryClassificationC6", builder::dictionaryClassificationC6);
        Args.setIfPresent(data, "deliveryMode", builder::deliveryMode);
        Args.setIfPresent(data, "deliverySubscriptionType", builder::deliverySubscriptionType);
        Args.setIfPresent(data, "deliveryComposition", builder::deliveryComposition);
        Args.setIfPresent(data, "deliveryAdvertisementCapability", builder::deliveryAdvertisementCapability);
        Args.setIfPresent(data, "distributionModel", builder::distributionModel);
        Args.setIfPresent(data, "mediaFormat", builder::mediaFormat);

        return builder.build();
    }

    StackedAdvertisementMetadata buildStackedAdvertisementMetadata(Object data) {
        StackedAdvertisementMetadata.Builder builder = new StackedAdvertisementMetadata.Builder();
        Map<String, String> labels = Args.getArgValue(data, "labels");
        if (labels != null && !labels.isEmpty()) {
            builder.customLabels(labels);
        }
        Args.setIfPresent(data, "fee", builder::fee);
        Args.setIfPresent(data, "uniqueId", builder::uniqueId);
        Args.setIfPresent(data, "title", builder::title);
        Args.setIfPresent(data, "serverCampaignId", builder::serverCampaignId);
        Args.setIfPresent(data, "placementId", builder::placementId);
        Args.setIfPresent(data, "siteId", builder::siteId);

        return builder.build();
    }
    AssetMetadata buildAssetMetadata(Object data) {
        if (!(data instanceof Map)) {
            return null;
        }
        if ("contentMetadata".equals(Args.getArgValue(data, "type"))) {
            ContentMetadata.Builder builder = new ContentMetadata.Builder();
            Map<String, Object> stack = Args.getArgValue(data, "stack");
            if (stack != null && !stack.isEmpty()) {
                for (Map.Entry<String, Object> entry : stack.entrySet()) {
                    builder.setStack(entry.getKey(), buildStackedContentMetadata(entry.getValue()));
                }
            }
            Map<String, String> labels = Args.getArgValue(data, "labels");
            if (labels != null && !labels.isEmpty()) {
                builder.customLabels(labels);
            }
            Args.setIfPresent(data, "mediaType", builder::mediaType);
            Args.setIfPresent(data, "classifyAsAudioStream", builder::classifyAsAudioStream);
            Args.setIfPresent(data, "classifyAsCompleteEpisode", builder::classifyAsCompleteEpisode);
            Args.setIfPresent(data, "carryTvAdvertisementLoad", builder::carryTvAdvertisementLoad);
            Args.setIfPresent(data, "uniqueId", builder::uniqueId);
            Args.setLongIfPresent(data, "length", builder::length);
            Args.setIfPresent(data, "totalSegments", builder::totalSegments);
            Args.setIfPresent(data, "publisherName", builder::publisherName);
            Args.setIfPresent(data, "programTitle", builder::programTitle);
            Args.setIfPresent(data, "episodeTitle", builder::episodeTitle);
            Args.setIfPresent(data, "episodeSeasonNumber", builder::episodeSeasonNumber);
            Args.setIfPresent(data, "episodeNumber", builder::episodeNumber);
            Args.setIfPresent(data, "genreName", builder::genreName);
            Args.setIfPresent(data, "genreId", builder::genreId);
            Args.setDateIfPresent(data, "productionDate", builder::dateOfProduction);
            Args.setTimeIfPresent(data, "productionTime", builder::timeOfProduction);
            Args.setDateIfPresent(data, "digitalAiringDate", builder::dateOfDigitalAiring);
            Args.setTimeIfPresent(data, "digitalAiringTime", builder::timeOfDigitalAiring);
            Args.setDateIfPresent(data, "tvAiringDate", builder::dateOfTvAiring);
            Args.setTimeIfPresent(data, "tvAiringTime", builder::timeOfTvAiring);
            Args.setIfPresent(data, "stationTitle", builder::stationTitle);
            Args.setIfPresent(data, "stationCode", builder::stationCode);
            Args.setIfPresent(data, "programId", builder::programId);
            Args.setIfPresent(data, "episodeId", builder::episodeId);
            Args.setIfPresent(data, "networkAffiliate", builder::networkAffiliate);
            Args.setIfPresent(data, "fee", builder::fee);
            Args.setIfPresent(data, "clipUrl", builder::clipUrl);
            Args.setIfPresent(data, "playlistTitle", builder::playlistTitle);
            Args.setIfPresent(data, "feedType", builder::feedType);
            Args.setDimensionsIfPresent(data, "videoDimensions", builder::videoDimensions);
            Args.setIfPresent(data, "dictionaryClassificationC3", builder::dictionaryClassificationC3);
            Args.setIfPresent(data, "dictionaryClassificationC4", builder::dictionaryClassificationC4);
            Args.setIfPresent(data, "dictionaryClassificationC6", builder::dictionaryClassificationC6);
            Args.setIfPresent(data, "deliveryMode", builder::deliveryMode);
            Args.setIfPresent(data, "deliverySubscriptionType", builder::deliverySubscriptionType);
            Args.setIfPresent(data, "deliveryComposition", builder::deliveryComposition);
            Args.setIfPresent(data, "deliveryAdvertisementCapability", builder::deliveryAdvertisementCapability);
            Args.setIfPresent(data, "distributionModel", builder::distributionModel);
            Args.setIfPresent(data, "mediaFormat", builder::mediaFormat);

            return builder.build();
        } else if ("advertisementMetadata".equals(Args.getArgValue(data, "type"))) {
            AdvertisementMetadata.Builder builder = new AdvertisementMetadata.Builder();
            Map<String, Object> stack = Args.getArgValue(data, "stack");
            if (stack != null && !stack.isEmpty()) {
                for (Map.Entry<String, Object> entry : stack.entrySet()) {
                    builder.setStack(entry.getKey(), buildStackedAdvertisementMetadata(entry.getValue()));
                }
            }

            Map<String, String> labels = Args.getArgValue(data, "labels");
            if (labels != null && !labels.isEmpty()) {
                builder.customLabels(labels);
            }
            Object relatedContentMetadata = Args.getArgValue(data, "relatedContentMetadata");
            if (relatedContentMetadata != null) {
                builder.relatedContentMetadata((ContentMetadata) buildAssetMetadata(relatedContentMetadata));
            }
            Args.setIfPresent(data, "mediaType", builder::mediaType);
            Args.setIfPresent(data, "classifyAsAudioStream", builder::classifyAsAudioStream);
            Args.setDimensionsIfPresent(data, "videoDimensions", builder::videoDimensions);
            Args.setLongIfPresent(data, "length", builder::length);
            Args.setIfPresent(data, "fee", builder::fee);
            Args.setIfPresent(data, "clipUrl", builder::clipUrl);
            Args.setIfPresent(data, "breakNumber", builder::breakNumber);
            Args.setIfPresent(data, "totalBreaks", builder::totalBreaks);
            Args.setIfPresent(data, "numberInBreak", builder::numberInBreak);
            Args.setIfPresent(data, "totalInBreak", builder::totalInBreak);
            Args.setIfPresent(data, "uniqueId", builder::uniqueId);
            Args.setIfPresent(data, "title", builder::title);
            Args.setIfPresent(data, "server", builder::server);
            Args.setIfPresent(data, "callToActionUrl", builder::callToActionUrl);
            Args.setIfPresent(data, "serverCampaignId", builder::serverCampaignId);
            Args.setIfPresent(data, "placementId", builder::placementId);
            Args.setIfPresent(data, "siteId", builder::siteId);
            Args.setIfPresent(data, "deliveryType", builder::deliveryType);
            Args.setIfPresent(data, "owner", builder::owner);

            return builder.build();
        }
        return null;
    }

    class FlutterOnStreamingStateChangeListener implements StreamingListener {
        final String refId;

        FlutterOnStreamingStateChangeListener(String refId) {
            this.refId = refId;
        }

        @Override
        public void onStateChanged(int oldState, int newState, Map<String, String> eventLabels){
            synchronized (lock) {
                HashMap<String, Object> params = new HashMap<>();
                params.put(Args.REF_ID, refId);
                params.put("oldState", oldState);
                params.put("newState", newState);
                params.put("eventLabels", eventLabels);
                if (attachEvent == null) {
                    pendingOnStreamingStateChanged.add(params);
                } else {
                    mainThreadHandler.post(() -> attachEvent.success(params));
                }
            }
        }
    }
}
