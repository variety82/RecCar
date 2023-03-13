package com.heros.api.car.entity;

import com.heros.api.user.entity.User;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "CAR")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "CAR_ID", columnDefinition = "INT UNSIGNED")
    private long carId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USER_ID")
    private User user;

    @Column(name = "CAR_NUMBER")
    private String carNumber;

    @Column(name = "CAR_MANUFACTURER")
    private String carManufacturer;

    @Column(name = "CAR_MODEL")
    private String carModel;

    @Column(name = "CAR_FUEL")
    private String carFuel;

    @Column(name = "RENTAL_DATE")
    private LocalDateTime rentalDate;

    @Column(name = "RETURN_DATE")
    private LocalDateTime returnDate;

    @Column(name = "RENTAL_COMPANY")
    private String rentalCompany;

    @Column(name = "RETURNED", columnDefinition="tinyint(1)")
    private boolean returned;

    @Column(name = "INITIAL_VIDEO")
    private String initialVideo;

    @Column(name = "LATTER_VIDEO")
    private String latterVideo;

    @Column(name = "NEW_DAMAGE_COUNT")
    private int newDamageCount;

    @Builder
    public Car(String carNumber, String carManufacturer, String carModel, String carFuel, LocalDateTime rentalDate, LocalDateTime returnDate, String rentalCompany, boolean returned, String initialVideo, String latterVideo, int newDamageCount) {
        this.carNumber = carNumber;
        this.carManufacturer = carManufacturer;
        this.carModel = carModel;
        this.carFuel = carFuel;
        this.rentalDate = rentalDate;
        this.returnDate = returnDate;
        this.rentalCompany = rentalCompany;
        this.returned = returned;
        this.initialVideo = initialVideo;
        this.latterVideo = latterVideo;
        this.newDamageCount = newDamageCount;
    }
}