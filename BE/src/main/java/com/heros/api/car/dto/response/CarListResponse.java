package com.heros.api.car.dto.response;

import com.heros.api.car.entity.Car;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CarListResponse {
    @Schema(description = "carId", example = "1", required = true)
    private long carId;
    @Schema(description = "빌린 날짜", example = "2019-11-12T16:34:30.388")
    private LocalDateTime rentalDate;
    @Schema(description = "반납 날짜", example = "2019-11-12T16:34:30.388")
    private LocalDateTime returnDate;
    @Schema(description = "렌탈 회사", example = "쏘카")
    private String rentalCompany;
    @Schema(description = "추가된 파손 개수", example = "3")
    private int damage;

    public CarListResponse(Car car) {
        this.carId = car.getCarId();
        this.rentalDate = car.getRentalDate();
        this.returnDate = car.getReturnDate();
        this.rentalCompany = car.getRentalCompany();
        this.damage = car.getLatterDamageCount() - car.getInitialDamageCount();
    }
}
