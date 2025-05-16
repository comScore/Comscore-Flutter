package com.comscore.flutter.streaming.utils;

import static com.comscore.flutter.Args.getArgValue;

public class ParsedDate {
    public final Integer year, month, day;
    public ParsedDate (Object data) {
        if (data == null) {
            year = null;
            month = null;
            day = null;
            return;
        }
        year = getArgValue(data, "year");
        month = getArgValue(data, "month");
        day = getArgValue(data, "day");
    }

    public boolean isValid() {
        return year != null && month != null && day != null;
    }
}
