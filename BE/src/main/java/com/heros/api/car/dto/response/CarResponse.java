package com.heros.api.car.dto.response;

import com.heros.api.car.entity.Car;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CarResponse {
    @Schema(description = "carId", example = "1", required = true)
    private long carId;
    @Schema(description = "자동차 번호", example = "12삼 4567")
    private String carNumber;
    @Schema(description = "자동차 제조사", example = "현대")
    private String carManufacturer;
    @Schema(description = "자동차 모델명", example = "쏘나타")
    private String carModel;
    @Schema(description = "자동차 연료", example = "식용유")
    private String carFuel;
    @Schema(description = "빌린 날짜", example = "2019-11-12T16:34:30.388")
    private LocalDateTime rentalDate;
    @Schema(description = "반납 날짜", example = "2019-11-12T16:34:30.388")
    private LocalDateTime returnDate;
    @Schema(description = "렌탈 회사", example = "쏘카")
    private String rentalCompany;
    @Schema(description = "반납 여부", example = "true")
    private boolean returned;
    @Schema(description = "대여시 앞부분 파손", example = "3")
    private int initialFrontDamageCount;
    @Schema(description = "대여시 중간 파손", example = "2")
    private int initialMidDamageCount;
    @Schema(description = "대여시 뒷부분 파손", example = "1")
    private int initialBackDamageCount;
    @Schema(description = "대여시 바퀴 파손", example = "0")
    private int initialWheelDamageCount;
    @Schema(description = "반납시 앞부분 파손", example = "3")
    private int latterFrontDamageCount;
    @Schema(description = "반납시 중간 파손", example = "2")
    private int latterMidDamageCount;
    @Schema(description = "반납시 뒷부분 파손", example = "1")
    private int latterBackDamageCount;
    @Schema(description = "반납시 바퀴 파손", example = "0")
    private int latterWheelDamageCount;


    public CarResponse(Car car) {
        this.carId = car.getCarId();
        this.carNumber = car.getCarNumber();
        this.carManufacturer = car.getCarManufacturer();
        this.carModel = car.getCarModel();
        this.carFuel = car.getCarFuel();
        this.rentalDate = car.getRentalDate();
        this.returnDate = car.getReturnDate();
        this.rentalCompany = car.getRentalCompany();
        this.returned = car.isReturned();
        this.initialFrontDamageCount = car.getInitialFrontDamageCount();
        this.initialMidDamageCount = car.getInitialMidDamageCount();
        this.initialBackDamageCount = car.getInitialBackDamageCount();
        this.initialWheelDamageCount = car.getInitialWheelDamageCount();
        this.latterFrontDamageCount = car.getLatterFrontDamageCount();
        this.latterMidDamageCount = car.getLatterMidDamageCount();
        this.latterBackDamageCount = car.getLatterBackDamageCount();
        this.latterWheelDamageCount = car.getLatterWheelDamageCount();
    }
}
