package com.comscore.flutter;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import static com.comscore.flutter.Args.*;

import com.comscore.ClientConfiguration;
import com.comscore.PartnerConfiguration;
import com.comscore.PublisherConfiguration;

import java.util.Map;

public class ClientConfigurationMethodCallHandler implements MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "newInstance": {
                ClientConfiguration.Builder builder;
                String clientType = Args.getArgValue(call.arguments, TYPE);
                String clientId = Args.getArgValue(call.arguments, CLIENT_ID);
                if ("publisherConfiguration".equals(clientType)) {
                    builder = new PublisherConfiguration.Builder();
                    ((PublisherConfiguration.Builder) builder).publisherId(clientId);
                } else if ("partnerConfiguration".equals(clientType)) {
                    builder = new PartnerConfiguration.Builder();
                    ((PartnerConfiguration.Builder) builder).partnerId(clientId);
                    String externalClientId = Args.getArgValue(call.arguments, "externalClientId");
                    if (externalClientId != null) {
                        ((PartnerConfiguration.Builder) builder).externalClientId(externalClientId);
                    }
                } else {
                    result.error("UNKNOWN_CLIENT_TYPE", "The ClientConfiguration type " + Args.getArgValue(call.arguments, TYPE) + " is unknown", null);
                    return;
                }
                Args.setIfPresent(call.arguments, "httpRedirectCaching", builder::httpRedirectCaching);
                Args.setIfPresent(call.arguments, "keepAliveMeasurement", builder::keepAliveMeasurement);
                Args.setIfPresent(call.arguments, "secureTransmission", builder::secureTransmission);
                Args.setIfPresent(call.arguments, "persistentLabels", builder::persistentLabels);
                Args.setIfPresent(call.arguments, "startLabels", builder::startLabels);

                ClientConfiguration client = null;
                if ("publisherConfiguration".equals(clientType)) {
                    client = ((PublisherConfiguration.Builder) builder).build();
                } else {
                    client = ((PartnerConfiguration.Builder) builder).build();
                }
                String refId = ObjTracker.trackObj(client);
                result.success(refId);
                break;
            }
            case "getClientId": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                String clientId = null;
                String clientType = Args.getArgValue(call.arguments, TYPE);
                if ("publisherConfiguration".equals(clientType)) {
                    clientId = ((PublisherConfiguration) client).getPublisherId();
                } else if ("partnerConfiguration".equals(clientType)) {
                    clientId = ((PartnerConfiguration) client).getPartnerId();
                }
                result.success(clientId);
                break;
            }
            case "removeAllPersistentLabels": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                client.removeAllPersistentLabels();
                result.success(null);
                break;
            }
            case "getStartLabels": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.getStartLabels());
                break;
            }
            case "containsStartLabel": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.containsStartLabel(Args.getArgValue(call.arguments, LABEL_NAME)));
                break;
            }
            case "removePersistentLabel": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                client.removePersistentLabel(Args.getArgValue(call.arguments, LABEL_NAME));
                result.success(null);
                break;
            }
            case "setPersistentLabel": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                client.setPersistentLabel(Args.getArgValue(call.arguments, LABEL_NAME), Args.getArgValue(call.arguments, LABEL_VALUE));
                result.success(null);
                break;
            }
            case "getPersistentLabel": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.getPersistentLabel(Args.getArgValue(call.arguments, LABEL_NAME)));
                break;
            }
            case "getPersistentLabels": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.getPersistentLabels());
                break;
            }
            case "containsPersistentLabel": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.containsPersistentLabel(Args.getArgValue(call.arguments, LABEL_NAME)));
                break;
            }
            case "addPersistentLabels": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                client.addPersistentLabels(Args.getArgValue(call.arguments, LABELS));
                result.success(null);
                break;
            }
            case "isKeepAliveMeasurementEnabled": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.isKeepAliveMeasurementEnabled());
                break;
            }
            case "isSecureTransmissionEnabled": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.isSecureTransmissionEnabled());
                break;
            }
            case "isHttpRedirectCachingEnabled": {
                ClientConfiguration client = ObjTracker.getTrackedObjFromArguments(call.arguments);
                result.success(client.isHttpRedirectCachingEnabled());
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }
}
