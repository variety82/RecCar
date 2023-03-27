package com.heros.api.calendar.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.heros.api.user.entity.User;
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

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    @JsonIgnore
    private User user;

    @Builder
    public Calendar(LocalDateTime calendarDate, String title, String memo, User user) {
        this.calendarDate = calendarDate;
        this.title = title;
        this.memo = memo;
        this.user = user;
    }
}
