package com.heros.api.calendar.repository;

import com.heros.api.calendar.entity.Calendar;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CalendarRepository extends JpaRepository<Calendar, Long>, CalendarRepositorySupport  {
    @Override
    void deleteById(Long calendarId);
    void deleteAllByUserId(Long userId);
}
