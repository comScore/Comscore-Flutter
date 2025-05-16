package com.comscore.flutter.streaming.utils;

import static com.comscore.flutter.Args.getArgValue;

public class ParsedDimensions {
    public final Integer width, height;
    public ParsedDimensions(Object data) {
        if (data == null) {
            width = null;
            height = null;
            return;
        }
        width = getArgValue(data, "width");
        height = getArgValue(data, "height");
    }

    public boolean isValid() {
        return width != null && height != null;
    }
}
