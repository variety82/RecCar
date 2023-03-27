package com.heros.api.calendar.repository;

import com.heros.api.calendar.entity.Calendar;

import java.util.List;

public interface CalendarRepositorySupport {
    List<Calendar> getCalendars(Long userId);
}
