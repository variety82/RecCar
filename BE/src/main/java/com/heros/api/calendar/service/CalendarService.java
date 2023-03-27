package com.heros.api.calendar.service;

import com.heros.api.calendar.entity.Calendar;
import com.heros.api.calendar.repository.CalendarRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CalendarService {

    private final CalendarRepository calendarRepository;

    public List<Calendar> getCalendar(Long userId) {
        List<Calendar> calendars = calendarRepository.getCalendars(userId);

        return calendars;
    }
}
