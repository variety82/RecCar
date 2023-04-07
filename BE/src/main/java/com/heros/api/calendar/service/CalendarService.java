package com.heros.api.calendar.service;

import com.heros.api.calendar.dto.request.CalendarModifyRequest;
import com.heros.api.calendar.dto.request.CalendarRequest;
import com.heros.api.calendar.dto.response.CalendarResponse;
import com.heros.api.calendar.entity.Calendar;
import com.heros.api.calendar.repository.CalendarRepository;
import com.heros.api.car.dto.request.CarCreate;
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

    public Calendar getOneCalendar(Long calendarId) {
        Calendar calendar = calendarRepository.findById(calendarId).orElse(null);
        return calendar;
    }

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

    public void updateCalendar(CalendarModifyRequest calendarModifyRequest, Long userId) {
        Calendar calendar = calendarModifyRequest.toEntity(userId);
        calendarRepository.save(calendar);
    }

    public void deleteCalendar(Long calendarId) {
        calendarRepository.deleteById(calendarId);
    }

    public void createCarCalendar(CarCreate carCreate, Long userId) {
        String rentalTitle = carCreate.getCarManufacturer() + " " + carCreate.getCarModel() + " " + carCreate.getCarNumber() +  " 대여";
        String returnTitle = carCreate.getCarManufacturer() + " " + carCreate.getCarModel() + " " + carCreate.getCarNumber() +  " 반납";

        Calendar rentalCarCalendar = Calendar.builder()
                .calendarDate(carCreate.getRentalDate())
                .title(rentalTitle)
                .isAuto(true)
                .memo("")
                .userId(userId)
                .build();

        Calendar returnCarCalendar = Calendar.builder()
                .calendarDate(carCreate.getReturnDate())
                .title(returnTitle)
                .isAuto(true)
                .memo("")
                .userId(userId)
                .build();

        calendarRepository.save(rentalCarCalendar);
        calendarRepository.save(returnCarCalendar);
    }
}
