package com.comscore.flutter;

import com.comscore.flutter.streaming.utils.ParsedDate;
import com.comscore.flutter.streaming.utils.ParsedDimensions;
import com.comscore.flutter.streaming.utils.ParsedTime;

import java.util.Map;
import java.util.Objects;
import java.util.function.BiConsumer;
import java.util.function.Consumer;
import java.util.function.Function;

public class Args {
    public static String REF_ID = "refId";
    public static String TYPE = "type";
    public static String CLIENT_ID = "clientId";
    public static String LABEL_NAME = "labelName";
    public static String LABEL_VALUE = "labelValue";
    public static String LABELS = "labels";
    public static String PUBLISHER_ID = "publisherId";
    public static String PARTNER_ID = "partnerId";
    public static String EVENT_INFO_REF_ID = "eventInfoRefId";
    public static String DISTRIBUTOR_PARTNER_ID = "distributorPartnerId";
    public static String DISTRIBUTOR_CONTENT_ID = "distributorContentId";
    public static String PUBLISHER_UNIQUE_DEVICE_ID = "publisherUniqueDeviceId";
    public static String D_KEY = "dkey";
    public static String URL = "url";
    public static String LABEL_ORDER = "labelOrder";
    public static String LIVE_POINT_URL = "liveEndpointUrl";
    public static String OFFLINE_FLUSH_END_POINT_URL = "offlineFlushEndpointUrl";
    public static String APP_NAME = "appName";
    public static String APP_VERSION = "appVersion";
    public static String ENABLED = "enabled";
    public static String LIVE_TRANSMISSION_MODE = "liveTransmissionMode";
    public static String OFFLINE_CACHE_MODE = "offlineCacheMode";
    public static String USAGE_PROPERTIES_AUTO_UPDATE_MODE = "usagePropertiesAutoUpdateMode";
    public static String INTERVAL = "interval";
    public static String MAX = "max";
    public static String MINUTES = "minutes";
    public static String DAYS = "days";
    public static String PRECISION = "precision";
    public static final String POSITION = "position";
    public static final String RATE = "rate";
    public static final String MEDIA_PLAYER_NAME = "mediaPlayerName";
    public static final String MEDIA_PLAYER_VERSION = "mediaPlayerVersion";
    public static final String METADATA = "metadata";
    public static final String IMPLEMENTATION_ID = "implementationId";
    public static final String PROJECT_ID = "projectId";
    public static final String SEGMENT_NUMBER = "segmentNumber";
    public static final String DVR_WINDOW = "dvrWindow";
    public static String getRefId(Object rawArgs) {
        return (String) ((Map<String, Object>) rawArgs).get(REF_ID);
    }

    public static <T> T getArgValue(Object rawArgs, String argValue) {
        return (T) ((Map<String, Object>) rawArgs).get(argValue);
    }

    public static <T> void setIfPresent(Object data, String key, Consumer<T> setter) {
        T value = getArgValue(data, key);
        if (value != null) {
            setter.accept(value);
        }
    }

    public static <T> void setLongIfPresent(Object data, String key, Consumer<Long> setter) {
        Object valueObj = getArgValue(data, key);
        if (valueObj != null) {
            long value = 0;
            if (valueObj instanceof Integer) {
                value = ((Integer) valueObj).longValue();
            } else if (valueObj instanceof Long) {
                value = (long) valueObj;
            } else if (valueObj instanceof String) {
                value = Long.parseLong((String) valueObj);
            }
            setter.accept(value);
        }
    }

    public static void setDimensionsIfPresent(Object data, String key, BiConsumer<Integer, Integer> setter) {
        ParsedDimensions dimensions = new ParsedDimensions(getArgValue(data, key));
        if (dimensions.isValid()) {
            setter.accept(dimensions.width, dimensions.height);
        }
    }

    public static void setDateIfPresent(Object data, String key, TriFunction<Integer, Integer,Integer, Object> setter) {
        ParsedDate date = new ParsedDate(getArgValue(data, key));
        if (date.isValid()) {
            setter.accept(date.year, date.month, date.day);
        }
    }

    public static void setTimeIfPresent(Object data, String key, BiConsumer<Integer,Integer> setter) {
        ParsedTime time = new ParsedTime(getArgValue(data, key));
        if (time.isValid()) {
            setter.accept(time.hour, time.minute);
        }
    }

    @FunctionalInterface
    public interface TriFunction<A,B,C,R> {
        R accept(A a, B b, C c);
    }
}
