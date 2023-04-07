package com.heros.exception.customException;

import com.heros.exception.ErrorCode;

public class CarException extends BusinessException{
    public CarException(String message, ErrorCode errorCode) {
        super(message, errorCode);
    }

    public CarException(ErrorCode errorCode) {
        super(errorCode);
    }
}
