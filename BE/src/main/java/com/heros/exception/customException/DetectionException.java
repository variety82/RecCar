package com.heros.exception.customException;

import com.heros.exception.ErrorCode;

public class DetectionException extends BusinessException{
    public DetectionException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

    public DetectionException(ErrorCode errorCode) {
        super(errorCode);
    }
}
