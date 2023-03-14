package com.heros.api.car.entity;

import com.heros.api.car.dto.request.CarModify;
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

    @ManyToOne
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
    public Car(User user, String carNumber, String carManufacturer, String carModel, String carFuel, LocalDateTime rentalDate, LocalDateTime returnDate, String rentalCompany, boolean returned, String initialVideo, String latterVideo, int newDamageCount) {
        this.user = user;
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

    public Car(CarModify carModify, Car car) {
        this.carId = carModify.getCarId();
        this.user = car.getUser();
        this.carNumber = carModify.getCarNumber();
        this.carManufacturer = carModify.getCarManufacturer();
        this.carModel = carModify.getCarModel();
        this.carFuel = carModify.getCarFuel();
        this.rentalDate = carModify.getRentalDate();
        this.returnDate = carModify.getReturnDate();
        this.rentalCompany = carModify.getRentalCompany();
        this.returned = car.isReturned();
        this.initialVideo = carModify.getInitialVideo();
        this.latterVideo = carModify.getLatterVideo();
        this.newDamageCount = car.getNewDamageCount();
    }
}
