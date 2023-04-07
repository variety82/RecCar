package com.heros.api.calendar.controller;

import com.heros.api.calendar.dto.request.CalendarModifyRequest;
import com.heros.api.calendar.dto.request.CalendarRequest;
import com.heros.api.calendar.dto.response.CalendarResponse;
import com.heros.api.calendar.entity.Calendar;
import com.heros.api.calendar.service.CalendarService;
import com.heros.api.example.model.ErrorResponseExample;
import com.heros.api.user.entity.User;
import com.heros.exception.ErrorCode;
import com.heros.exception.customException.CarException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.List;

@Tag(name = "CalendarController", description = "캘린더 API")
@RestController
@RequestMapping("/api/v1/calendar/")
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarService calendarService;

    @Operation(summary = "캘린더 단건 조회", description = "캘린더 id로 캘린더 단건을 조회하는 메서드 입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = CalendarResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "{calendarId}")
    public ResponseEntity<?> getOneCalendar(@Schema(description = "조회할 calendar Id", example = "1") @NotNull @Min(1) @PathVariable Long calendarId) {
        Calendar oneCalendar = calendarService.getOneCalendar(calendarId);
        CalendarResponse calendarResponse = new CalendarResponse(oneCalendar);
        return ResponseEntity.ok().body(calendarResponse);
    }

    @Operation(summary = "캘린더 조회", description = "캘린더 조회 메서드 입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = CalendarResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "")
    public ResponseEntity<?> getCalendar(){
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        Long userId = user.getUserId();
        List<CalendarResponse> response = calendarService.getCalendar(userId);
        return ResponseEntity.ok().body(response);
    }

    @Operation(summary = "캘린더 등록", description = "캘린더 등록 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "success"),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @PostMapping(value = "")
    public ResponseEntity<?> calendarAdd(@Valid @RequestBody CalendarRequest calendarRequest) {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        Long userId = user.getUserId();

        calendarService.createCalendar(calendarRequest, userId);
        return ResponseEntity.status(201).body(null);
    }

    @Operation(summary = "캘린더 수정", description = "캘린더 수정 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success"),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @PutMapping(value = "")
    public ResponseEntity<?> calendarUpdate(@Valid @RequestBody CalendarModifyRequest calendarModifyRequest) {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        Long userId = user.getUserId();

        Calendar oneCalendar = calendarService.getOneCalendar(calendarModifyRequest.getCalendarId());
        if (calendarModifyRequest.isAuto() &&
                (!calendarModifyRequest.getTitle().equals(oneCalendar.getTitle()) ||
                        (!calendarModifyRequest.getCalendarDate().isEqual(oneCalendar.getCalendarDate())))) {
            throw (new CarException(ErrorCode.INVALID_UPDATE_VALUE));
        }

        calendarService.updateCalendar(calendarModifyRequest, userId);
        return ResponseEntity.status(201).body(null);
    }

    @Operation(summary = "캘린더 삭제", description = "캘린더 삭제 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success"),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @DeleteMapping(value = "{calendarId}")
    public ResponseEntity<?> calendarDelete(@Schema(description = "삭제할 calendar Id", example = "1") @NotNull @Min(1) @PathVariable Long calendarId) {
        Calendar oneCalendar = calendarService.getOneCalendar(calendarId);
        if (oneCalendar.isAuto()) {
            throw (new CarException(ErrorCode.INVALID_DELETE_VALUE));
        }

        calendarService.deleteCalendar(calendarId);
        return ResponseEntity.status(201).body(null);
    }
}
