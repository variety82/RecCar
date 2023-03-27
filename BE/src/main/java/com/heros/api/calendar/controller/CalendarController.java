package com.heros.api.calendar.controller;

import com.heros.api.calendar.entity.Calendar;
import com.heros.api.calendar.service.CalendarService;
import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.example.model.ErrorResponseExample;
import com.heros.exception.ErrorCode;
import com.heros.exception.customException.BusinessException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.List;

@Tag(name = "CalendarController", description = "캘린더 API")
@RestController
@RequestMapping("/api/v1/calendar/")
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarService calendarService;

    @Operation(summary = "캘린더 조회")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = PartWithDetectionInfoResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "{userId}")
    public ResponseEntity<?> getCalender(@Schema(description = "조회할 userId", example = "1") @NotNull @Min(1) @PathVariable Long userId){
        List<Calendar> response = calendarService.getCalendar(userId);
        if (response.size() == 0) {
            throw (new BusinessException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.ok().body(response);
    }
}
