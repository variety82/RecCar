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

    @Column(name = "INITIAL_FRONT_DAMAGE_COUNT")
    private int initialFrontDamageCount;

    @Column(name = "INITIAL_MID_DAMAGE_COUNT")
    private int initialMidDamageCount;

    @Column(name = "INITIAL_BACK_DAMAGE_COUNT")
    private int initialBackDamageCount;

    @Column(name = "INITIAL_WHEEL_DAMAGE_COUNT")
    private int initialWheelDamageCount;

    @Column(name = "LATTER_VIDEO")
    private String latterVideo;

    @Column(name = "LATTER_FRONT_DAMAGE_COUNT")
    private int latterFrontDamageCount;

    @Column(name = "LATTER_MID_DAMAGE_COUNT")
    private int latterMidDamageCount;

    @Column(name = "LATTER_BACK_DAMAGE_COUNT")
    private int latterBackDamageCount;

    @Column(name = "LATTER_WHEEL_DAMAGE_COUNT")
    private int latterWheelDamageCount;

    @Builder
    public Car(User user, String carNumber, String carManufacturer, String carModel, String carFuel, LocalDateTime rentalDate, LocalDateTime returnDate, String rentalCompany, boolean returned, String initialVideo, int initialFrontDamageCount, int initialMidDamageCount, int initialBackDamageCount, int initialWheelDamageCount, String latterVideo, int latterFrontDamageCount, int latterMidDamageCount, int latterBackDamageCount, int latterWheelDamageCount) {
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
        this.initialFrontDamageCount = initialFrontDamageCount;
        this.initialMidDamageCount = initialMidDamageCount;
        this.initialBackDamageCount = initialBackDamageCount;
        this.initialWheelDamageCount = initialWheelDamageCount;
        this.latterVideo = latterVideo;
        this.latterFrontDamageCount = latterFrontDamageCount;
        this.latterMidDamageCount = latterMidDamageCount;
        this.latterBackDamageCount = latterBackDamageCount;
        this.latterWheelDamageCount = latterWheelDamageCount;
    }

    public void ModifyCar(CarModify carModify) {
        this.carNumber = carModify.getCarNumber();
        this.carManufacturer = carModify.getCarManufacturer();
        this.carModel = carModify.getCarModel();
        this.carFuel = carModify.getCarFuel();
        this.rentalDate = carModify.getRentalDate();
        this.returnDate = carModify.getReturnDate();
        this.rentalCompany = carModify.getRentalCompany();
    }
}
