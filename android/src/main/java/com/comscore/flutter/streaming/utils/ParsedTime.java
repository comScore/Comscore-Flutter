package com.comscore.flutter.streaming.utils;

import static com.comscore.flutter.Args.getArgValue;

public class ParsedTime {
    public final Integer hour, minute;
    public ParsedTime (Object data) {
        if (data == null) {
            hour = null;
            minute = null;
            return;
        }
        hour = getArgValue(data, "hour");
        minute = getArgValue(data, "minute");
    }

    public boolean isValid() {
        return hour != null && minute != null;
    }
}
