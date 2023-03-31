package com.heros.api.calendar.dto.response;

import com.heros.api.calendar.entity.Calendar;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CalendarResponse {

    @Schema(description = "calendarId", example = "1", required = true)
    @NotNull
    @Min(1)
    private Long calendarId;

    @Schema(description = "등록 날짜", example = "2023-03-31T06:41:25.359Z")
    @NotNull
    private LocalDateTime calendarDate;

    @Schema(description = "제목", example = "제목입니다.")
    @NotNull
    private String title;

    @Schema(description = "메모", example = "메모입니다.")
    @NotNull
    private String memo;

    @Schema(description = "자동 생성 일정", example = "false")
    @NotNull
    private boolean isAuto;

    public CalendarResponse(Calendar calendar) {
        this.calendarId = calendar.getCalendarId();
        this.calendarDate = calendar.getCalendarDate();
        this.title = calendar.getTitle();
        this.memo = calendar.getMemo();
        this.isAuto = calendar.isAuto();
    }
}
