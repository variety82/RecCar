package com.heros.api.detectionInfo.dto.response;

import com.heros.api.car.entity.Car;
import com.heros.api.detectionInfo.entity.DetectionInfo;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class CarDetectionResponse {
    @Schema(description = "carId", example = "1")
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
    @Schema(description = "대여 파손 정보 리스트", example = "[detectionInfo]")
    private List<DetectionInfo> initialDetectionInfos;
    @Schema(description = "반납 파손 정보 리스트", example = "[detectionInfo]")
    private List<DetectionInfo> latterDetectionInfos;

    public CarDetectionResponse(Car car, List<DetectionInfo> initialDetectionInfos, List<DetectionInfo> latterDetectionInfos) {
        this.carId = car.getCarId();
        this.carNumber = car.getCarNumber();
        this.carManufacturer = car.getCarManufacturer();
        this.carModel = car.getCarModel();
        this.carFuel = car.getCarFuel();
        this.rentalDate = car.getRentalDate();
        this.returnDate = car.getReturnDate();
        this.rentalCompany = car.getRentalCompany();
        this.initialDetectionInfos = initialDetectionInfos;
        this.latterDetectionInfos = latterDetectionInfos;
    }
}
