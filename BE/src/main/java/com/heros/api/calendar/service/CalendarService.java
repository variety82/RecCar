package com.heros.api.calendar.service;

import com.heros.api.calendar.dto.request.CalendarModifyRequest;
import com.heros.api.calendar.dto.request.CalendarRequest;
import com.heros.api.calendar.dto.response.CalendarResponse;
import com.heros.api.calendar.entity.Calendar;
import com.heros.api.calendar.repository.CalendarRepository;
import com.heros.api.user.entity.User;
import com.heros.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CalendarService {

    private final CalendarRepository calendarRepository;
    private final UserRepository userRepository;

    public List<CalendarResponse> getCalendar(Long userId) {
        List<Calendar> calendars = calendarRepository.getCalendars(userId);
        List<CalendarResponse> responses = new ArrayList<>();
        for (Calendar calendar : calendars) {
            responses.add(new CalendarResponse(calendar));
        }
        return responses;
    }

    public void createCalendar(CalendarRequest calendarRequest, Long userId) {

        Calendar calendar = Calendar.builder()
                .userId(userId)
                .calendarDate(calendarRequest.getCalendarDate())
                .title(calendarRequest.getTitle())
                .memo(calendarRequest.getMemo())
                .isAuto(calendarRequest.isAuto())
                .build();
        calendarRepository.save(calendar);
    }

    public void updateCalendar(CalendarModifyRequest calendarModifyRequest) {
//        User user = userRepository.findById(calendarModifyRequest.get).orElseThrow();
//        Calendar calendar = calendarModifyRequest.toEntity(user);
//        calendarRepository.save(calendar);
    }

    public void deleteCalendar(Long calendarId) {
        calendarRepository.deleteById(calendarId);
    }
}
