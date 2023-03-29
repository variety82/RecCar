package com.heros.api.calendar.service;

import com.heros.api.calendar.dto.request.CalendarModifyRequest;
import com.heros.api.calendar.dto.request.CalendarRequest;
import com.heros.api.calendar.entity.Calendar;
import com.heros.api.calendar.repository.CalendarRepository;
import com.heros.api.user.entity.User;
import com.heros.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CalendarService {

    private final CalendarRepository calendarRepository;
    private final UserRepository userRepository;

    public List<Calendar> getCalendar(Long userId) {
        List<Calendar> calendars = calendarRepository.getCalendars(userId);

        return calendars;
    }

    public void createCalendar(CalendarRequest calendarRequest) {
        User user = userRepository.findById(calendarRequest.getUserId()).orElseThrow(IllegalArgumentException::new);
        Calendar calendar = Calendar.builder()
                .user(user)
                .calendarDate(calendarRequest.getCalendarDate())
                .title(calendarRequest.getTitle())
                .memo(calendarRequest.getMemo())
                .build();
        calendarRepository.save(calendar);
    }

    public void updateCalendar(CalendarModifyRequest calendarModifyRequest) {
        User user = userRepository.findById(calendarModifyRequest.getUserId()).orElseThrow();
        Calendar calendar = calendarModifyRequest.toEntity(user);
        calendarRepository.save(calendar);
    }

    public void deleteCalendar(Long calendarId) {
        calendarRepository.deleteById(calendarId);
    }
}
