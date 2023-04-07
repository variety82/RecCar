package com.heros.api.calendar.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CalendarRequest {

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

}
