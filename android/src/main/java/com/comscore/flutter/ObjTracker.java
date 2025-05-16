package com.comscore.flutter;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class ObjTracker {

    public static String ERROR_OBJ_REF_NOT_FOUND = "OBJ_REF_NOT_FOUND";
    private static final Map<String, Object> objects = new HashMap<>();

    public static String trackObj(Object obj) {
        if (obj == null) {
            return null;
        }
        String refId = UUID.randomUUID().toString()+ "-" + System.identityHashCode(obj);
        objects.put(refId, obj);
        return refId;
    }

    public static <T> T get(String refId) {
        return (T) objects.get(refId);
    }

    public static <T> T getTrackedObjFromArguments(Object args) {
        return get(Args.getRefId(args));
    }

    public static <T> T getTrackedObjFromArguments(Object args, String argRefIdName) {
        return get(Args.getArgValue(args, argRefIdName));
    }

    public static <T> T remove(String refId) {
        return (T) objects.remove(refId);
    }
}
