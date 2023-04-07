package com.heros.exception;

public enum ErrorCode {

    // Global
    INVALID_INPUT_VALUE(400, "G001", "Invalid Input Value"),
    HANDLE_ACCESS_DENIED(403, "G002", "Access is Denied"),
    PAGE_NOT_FOUND(404, "G003", "요청하신 정보가 없습니다. id 등 파라미터를 확인하세요"),
    METHOD_NOT_ALLOWED(405, "G004", "Invalid Input Value"),
    INTERNAL_SERVER_ERROR(500, "G005", "Internal Server Error"),


    // Car
    DATE_INPUT_INVALID(400, "C001", "대여기간이 유효하지 않습니다. 렌트 시작일이 반납 기간 이전인지 확인하세요"),

    // Detection
    PART_INPUT_INVALID(400, "D001", "잘못된 차량 부위(part)입니다"),
    DAMAGE_INPUT_INVALID(400, "D002", "잘못된 파손 정보(damage)입니다"),

    // Calendar
    INVALID_UPDATE_VALUE(400, "A001", "자동 생성된 달력은 제목과 날짜를 수정할 수 없습니다. Check value isAuto"),
    INVALID_DELETE_VALUE(400, "A002", "자동 생성된 달력은 삭제할 수 없습니다. Check value isAuto");


    private final String code;
    private final String message;
    private int status;

    ErrorCode(final int status, final String code, final String message) {
        this.code = code;
        this.message = message;
        this.status = status;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public int getStatus() {
        return status;
    }
}
