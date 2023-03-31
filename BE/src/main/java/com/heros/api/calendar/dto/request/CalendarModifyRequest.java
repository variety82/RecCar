package com.heros.api.calendar.dto.request;

import com.heros.api.calendar.entity.Calendar;
import com.heros.api.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CalendarModifyRequest {

    @Schema(description = "calendarId", example = "1", required = true)
    @NotNull
    @Min(1)
    private Long calendarId;

    @Schema(description = "일정 날짜", example = "2023-03-31T06:41:25.359Z")
    @NotNull
    private LocalDateTime calendarDate;

    @Schema(description = "제목", example = "제목입니다.")
    @NotNull
    private String title;

    @Schema(description = "메모", example = "메모입니다.")
    @NotNull
    private String memo;

    @Schema(description = "자동 등록 여부", example = "false")
    @NotNull
    private boolean isAuto;


    public Calendar toEntity(Long userId) {
        return Calendar.modifyBuilder()
                .calendarId(this.calendarId)
                .calendarDate(this.calendarDate)
                .memo(this.memo)
                .title(this.title)
                .userId(userId)
                .isAuto(this.isAuto)
                .build();
    }
}
