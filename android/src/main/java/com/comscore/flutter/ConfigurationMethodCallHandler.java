package com.comscore.flutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.comscore.Analytics;
import com.comscore.ClientConfiguration;
import com.comscore.CrossPublisherUniqueDeviceIdChangeListener;
import com.comscore.PartnerConfiguration;
import com.comscore.PublisherConfiguration;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class ConfigurationMethodCallHandler implements MethodCallHandler {

    EventChannel eventChannelCrossPublisherUniqueDeviceIdChanged;
    private EventChannel.EventSink attachEvent;
    private final Object lock = new Object();
    private final Handler mainThreadHandler = new Handler(Looper.getMainLooper());

    private final List<String> pendingOnCrossPublisherUniqueDeviceIdChanged = new ArrayList<>();
    private final FlutterCrossPublisherUniqueDeviceIdChangeListener flutterCrossPublisherUniqueDeviceIdChangeListener = new FlutterCrossPublisherUniqueDeviceIdChangeListener();


    public void setBinaryMessenger(BinaryMessenger binaryMessenger) {
        this.eventChannelCrossPublisherUniqueDeviceIdChanged = new EventChannel(binaryMessenger, "com.comscore.configuration.configuration_CrossPublisherUniqueDeviceIdChanged_channel");
        eventChannelCrossPublisherUniqueDeviceIdChanged.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                synchronized (lock) {
                    attachEvent = events;
                }
                mainThreadHandler.post(() -> {
                    for (String pending : pendingOnCrossPublisherUniqueDeviceIdChanged) {
                        attachEvent.success(pending);
                    }
                    pendingOnCrossPublisherUniqueDeviceIdChanged.clear();
                });
            }

            @Override
            public void onCancel(Object arguments) {
                Analytics.getConfiguration().removeCrossPublisherUniqueDeviceIdChangeListener(flutterCrossPublisherUniqueDeviceIdChangeListener);
                attachEvent = null;
            }
        });
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "enableImplementationValidationMode":
                Analytics.getConfiguration().enableImplementationValidationMode();
                result.success(null);
                break;
            case "addClient":
                Map<String, Object> args = (Map<String, Object>) call.arguments;
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(args);
                if (client != null) {
                    Analytics.getConfiguration().addClient(client);
                    result.success(null);
                } else {
                    result.error(ObjTracker.ERROR_OBJ_REF_NOT_FOUND, "Unable to find ClientConfiguration with id " + Args.getRefId(call.arguments) + " and type " + Args.getArgValue(call.arguments, Args.TYPE), args);
                }
                break;
            case "addCrossPublisherUniqueDeviceIdChangeListener":
                Analytics.getConfiguration().addCrossPublisherUniqueDeviceIdChangeListener(flutterCrossPublisherUniqueDeviceIdChangeListener);
                result.success(null);
                break;
            case "getPartnerConfiguration":
                PartnerConfiguration partnerToReturn = Analytics.getConfiguration().getPartnerConfiguration(Args.getArgValue(call.arguments, Args.PARTNER_ID));
                result.success(ObjTracker.trackObj(partnerToReturn));
                break;
            case "getPublisherConfiguration":
                PublisherConfiguration publisherToReturn = Analytics.getConfiguration().getPublisherConfiguration(Args.getArgValue(call.arguments, Args.PUBLISHER_ID));
                result.success(ObjTracker.trackObj(publisherToReturn));
                break;
            case "getPublisherConfigurations":
                List<PublisherConfiguration> publishers = Analytics.getConfiguration().getPublisherConfigurations();
                List<String> publisherRefIds = new ArrayList<>();
                for (PublisherConfiguration publisher : publishers) {
                    publisherRefIds.add(ObjTracker.trackObj(publisher));
                }
                result.success(publisherRefIds);
                break;
            case "getPartnerConfigurations":
                List<PartnerConfiguration> partners = Analytics.getConfiguration().getPartnerConfigurations();
                List<String> partnerRefIds = new ArrayList<>();
                for (PartnerConfiguration p : partners) {
                    partnerRefIds.add(ObjTracker.trackObj(p));
                }
                result.success(partnerRefIds);
                break;
            case "getLabelOrder":
                result.success(Arrays.asList(Analytics.getConfiguration().getLabelOrder()));
                break;
            case "setLabelOrder":
                List<String> labelOrder = Args.getArgValue(call.arguments, Args.LABEL_ORDER);
                Analytics.getConfiguration().setLabelOrder(labelOrder.toArray(new String[0]));
                result.success(null);
                break;
            case "setLiveEndpointUrl":
                Analytics.getConfiguration().setLiveEndpointUrl(Args.getArgValue(call.arguments, Args.LIVE_POINT_URL));
                result.success(null);
                break;
            case "setOfflineFlushEndpointUrl":
                Analytics.getConfiguration().setOfflineFlushEndpointUrl(Args.getArgValue(call.arguments, Args.OFFLINE_FLUSH_END_POINT_URL));
                result.success(null);
                break;
            case "setApplicationName":
                Analytics.getConfiguration().setApplicationName(Args.getArgValue(call.arguments, Args.APP_NAME));
                result.success(null);
                break;
            case "setApplicationVersion":
                Analytics.getConfiguration().setApplicationVersion(Args.getArgValue(call.arguments, Args.APP_VERSION));
                result.success(null);
                break;
            case "setPersistentLabel":
                Analytics.getConfiguration().setPersistentLabel(Args.getArgValue(call.arguments, Args.LABEL_NAME), Args.getArgValue(call.arguments, Args.LABEL_VALUE));
                result.success(null);
                break;
            case "removeAllPersistentLabels":
                Analytics.getConfiguration().removeAllPersistentLabels();
                result.success(null);
                break;
            case "removePersistentLabel":
                Analytics.getConfiguration().removePersistentLabel(Args.getArgValue(call.arguments, Args.LABEL_NAME));
                result.success(null);
                break;
            case "addPersistentLabels":
                Analytics.getConfiguration().addPersistentLabels(Args.getArgValue(call.arguments, Args.LABELS));
                result.success(null);
                break;
            case "setStartLabel":
                Analytics.getConfiguration().setStartLabel(Args.getArgValue(call.arguments, Args.LABEL_NAME), Args.getArgValue(call.arguments, Args.LABEL_VALUE));
                result.success(null);
                break;
            case "removeAllStartLabels":
                Analytics.getConfiguration().removeAllStartLabels();
                result.success(null);
                break;
            case "removeStartLabel":
                Analytics.getConfiguration().removeStartLabel(Args.getArgValue(call.arguments, Args.LABEL_NAME));
                result.success(null);
                break;
            case "addStartLabels":
                Analytics.getConfiguration().addStartLabels(Args.getArgValue(call.arguments, Args.LABELS));
                result.success(null);
                break;
            case "setKeepAliveMeasurementEnabled":
                Analytics.getConfiguration().setKeepAliveMeasurementEnabled(Args.getArgValue(call.arguments, Args.ENABLED));
                result.success(null);
                break;
            case "setLiveTransmissionMode":
                Analytics.getConfiguration().setLiveTransmissionMode(Args.getArgValue(call.arguments, Args.LIVE_TRANSMISSION_MODE));
                result.success(null);
                break;
            case "setOfflineCacheMode":
                Analytics.getConfiguration().setOfflineCacheMode(Args.getArgValue(call.arguments, Args.OFFLINE_CACHE_MODE));
                result.success(null);
                break;
            case "setUsagePropertiesAutoUpdateMode":
                Analytics.getConfiguration().setUsagePropertiesAutoUpdateMode(Args.getArgValue(call.arguments, Args.USAGE_PROPERTIES_AUTO_UPDATE_MODE));
                result.success(null);
                break;
            case "setUsagePropertiesAutoUpdateInterval":
                Analytics.getConfiguration().setUsagePropertiesAutoUpdateInterval(Args.getArgValue(call.arguments, Args.INTERVAL));
                result.success(null);
                break;
            case "setCacheMaxMeasurements":
                Analytics.getConfiguration().setCacheMaxMeasurements(Args.getArgValue(call.arguments, Args.MAX));
                result.success(null);
                break;
            case "setCacheMaxBatchFiles":
                Analytics.getConfiguration().setCacheMaxBatchFiles(Args.getArgValue(call.arguments, Args.MAX));
                result.success(null);
                break;
            case "setCacheMaxFlushesInARow":
                Analytics.getConfiguration().setCacheMaxFlushesInARow(Args.getArgValue(call.arguments, Args.MAX));
                result.success(null);
                break;
            case "setCacheMinutesToRetry":
                Analytics.getConfiguration().setCacheMinutesToRetry(Args.getArgValue(call.arguments, Args.MINUTES));
                result.success(null);
                break;
            case "setCacheMeasurementExpiry":
                Analytics.getConfiguration().setCacheMeasurementExpiry(Args.getArgValue(call.arguments, Args.DAYS));
                result.success(null);
                break;
            case "isEnabled":
                result.success(Analytics.getConfiguration().isEnabled());
                break;
            case "disable":
                Analytics.getConfiguration().disable();
                result.success(null);
                break;
            case "disableTcfIntegration":
                Analytics.getConfiguration().disableTcfIntegration();
                result.success(null);
                break;
            case "addIncludedPublisher":
                Analytics.getConfiguration().addIncludedPublisher(Args.getArgValue(call.arguments, Args.PUBLISHER_ID));
                result.success(null);
                break;
            case "setSystemClockJumpDetectionEnabled":
                Analytics.getConfiguration().setSystemClockJumpDetectionEnabled(Args.getArgValue(call.arguments, Args.ENABLED));
                result.success(null);
                break;
            case "setSystemClockJumpDetectionInterval":
                Analytics.getConfiguration().setSystemClockJumpDetectionInterval(((Integer) Args.getArgValue(call.arguments, Args.INTERVAL)).longValue());
                result.success(null);
                break;
            case "setSystemClockJumpDetectionPrecision":
                Analytics.getConfiguration().setSystemClockJumpDetectionPrecision(((Integer) Args.getArgValue(call.arguments, Args.PRECISION)).longValue());
                result.success(null);
                break;
            case "enableChildDirectedApplicationMode":
                Analytics.getConfiguration().enableChildDirectedApplicationMode();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    class FlutterCrossPublisherUniqueDeviceIdChangeListener implements CrossPublisherUniqueDeviceIdChangeListener {
        @Override
        public void onCrossPublisherUniqueDeviceIdChanged(String s) {
            synchronized (lock) {
                if (attachEvent == null) {
                    pendingOnCrossPublisherUniqueDeviceIdChanged.add(s);
                } else {
                    mainThreadHandler.post(() -> attachEvent.success(s));
                }
            }
        }
    }

}
