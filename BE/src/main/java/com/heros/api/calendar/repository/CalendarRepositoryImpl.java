package com.heros.api.calendar.repository;

import com.heros.api.calendar.entity.Calendar;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

import static com.heros.api.calendar.entity.QCalendar.calendar;

@Slf4j
@RequiredArgsConstructor
public class CalendarRepositoryImpl implements CalendarRepositorySupport{

    private final JPAQueryFactory queryFactory;

    @Override
    public List<Calendar> getCalendars(Long userId) {
        List<Calendar> fetch = queryFactory.selectFrom(calendar)
                .where(calendar.userId.eq(userId))
                .fetch();

        return fetch;
    }
}
