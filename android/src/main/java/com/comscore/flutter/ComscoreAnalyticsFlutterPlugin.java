package com.comscore.flutter;

import androidx.annotation.NonNull;

import com.comscore.flutter.streaming.StreamingAnalyticsMethodCallHandler;
import com.comscore.flutter.streaming.StreamingConfigurationMethodCallHandler;
import com.comscore.flutter.streaming.StreamingExtendedAnalyticsMethodCallHandler;
import com.comscore.flutter.streaming.StreamingPublisherConfigurationMethodCallHandler;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

/** ComscoreAnalyticsFlutterPlugin */
public class ComscoreAnalyticsFlutterPlugin implements FlutterPlugin {
  private final Map<String, MethodChannel> channels = new HashMap<>();
  private final ComscoreUtilsMethodCallHandler utilsMethodCallHandler = new ComscoreUtilsMethodCallHandler();
  private final ConfigurationMethodCallHandler configurationMethodCallHandler = new ConfigurationMethodCallHandler();
  private final AnalyticsMethodCallHandler analyticsMethodCallHandler = new AnalyticsMethodCallHandler();
  private final ClientConfigurationMethodCallHandler clientConfigurationMethodCallHandler = new ClientConfigurationMethodCallHandler();
  private final EventInfoMethodCallHandler eventInfoMethodCallHandler = new EventInfoMethodCallHandler();
  private final StreamingAnalyticsMethodCallHandler streamingAnalyticsMethodCallHandler = new StreamingAnalyticsMethodCallHandler();
  private final StreamingExtendedAnalyticsMethodCallHandler streamingExtendedAnalyticsMethodCallHandler = new StreamingExtendedAnalyticsMethodCallHandler();
  private final StreamingConfigurationMethodCallHandler streamingConfigurationMethodCallHandler = new StreamingConfigurationMethodCallHandler();
  private final StreamingPublisherConfigurationMethodCallHandler streamingPublisherConfigurationMethodCallHandler = new StreamingPublisherConfigurationMethodCallHandler();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    analyticsMethodCallHandler.setContext(flutterPluginBinding.getApplicationContext());
    configurationMethodCallHandler.setBinaryMessenger(flutterPluginBinding.getBinaryMessenger());
    streamingAnalyticsMethodCallHandler.setBinaryMessenger(flutterPluginBinding.getBinaryMessenger());

    addMethodChannel(flutterPluginBinding, "com.comscore.utils", utilsMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.analytics", analyticsMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.configuration", configurationMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.clientConfiguration", clientConfigurationMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.eventInfo", eventInfoMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.streaming.streamingAnalytics", streamingAnalyticsMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.streaming.streamingExtendedAnalytics", streamingExtendedAnalyticsMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.streaming.streamingConfiguration", streamingConfigurationMethodCallHandler);
    addMethodChannel(flutterPluginBinding, "com.comscore.streaming.streamingPublisherConfiguration", streamingPublisherConfigurationMethodCallHandler);
  }

  private void addMethodChannel(@NonNull FlutterPluginBinding flutterPluginBinding, String name, MethodCallHandler methodCallHandler) {
    MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), name);
    channel.setMethodCallHandler(methodCallHandler);
    channels.put(name, channel);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    for (Map.Entry<String, MethodChannel> entry : channels.entrySet()) {
      entry.getValue().setMethodCallHandler(null);
    }
  }
}
