package com.heros.api.calendar.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CalendarRequest {

    @Schema(description = "userId", example = "1", required = true)
    @NotNull
    @Min(1)
    private Long userId;

    @Schema(description = "등록 날짜", example = "2023-03-12T16:34:30.388")
    @NotNull
    private LocalDateTime calendarDate;

    @Schema(description = "제목", example = "제목입니다.")
    @NotNull
    private String title;

    @Schema(description = "메모", example = "제목입니다.")
    @NotNull
    private String memo;


}
