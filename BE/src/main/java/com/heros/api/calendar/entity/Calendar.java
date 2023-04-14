package com.heros.api.calendar.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "CALENDAR")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Calendar {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "CALENDAR_ID", columnDefinition = "INT UNSIGNED")
    private long calendarId;

    @Column(name = "CALENDAR_DATE")
    private LocalDateTime calendarDate;

    @Column(name = "TITLE")
    private String title;

    @Column(name = "CALENDAR_MEMO")
    private String memo;

    @Column(name = "USER_ID")
    private Long userId;

    @Column(name = "IS_AUTO", columnDefinition="tinyint(1)")
    private boolean isAuto;

    @Builder(builderMethodName = "modifyBuilder")
    public Calendar(long calendarId, LocalDateTime calendarDate, String title, String memo, Long userId, boolean isAuto) {
        this.calendarId = calendarId;
        this.calendarDate = calendarDate;
        this.title = title;
        this.memo = memo;
        this.userId = userId;
        this.isAuto = isAuto;
    }

    @Builder(builderMethodName = "builder")
    public Calendar(LocalDateTime calendarDate, String title, String memo, Long userId, boolean isAuto) {
        this.calendarDate = calendarDate;
        this.title = title;
        this.memo = memo;
        this.userId = userId;
        this.isAuto = isAuto;
    }

}
