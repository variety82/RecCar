package com.heros.api.detectionInfo.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.sql.Date;
import java.time.LocalDateTime;

@Data
@Schema(description = "렌트 내역 상세 조회")
public class RentDetailResponse {
    @Schema(description = "차량 PK")
    Long carId;
    @Schema(description = "차량 번호")
    String carNumber;
    @Schema(description = "차량 제조사")
    String carManufacturer;
    @Schema(description = "차량 모델")
    String carModel;
    @Schema(description = "차 연료")
    String carFuel;
    @Schema(description = "렌트한 날짜")
    LocalDateTime rentalDate;
    @Schema(description = "반납 날짜")
    LocalDateTime returnDate;
    @Schema(description = "렌트 회사")
    String rentalCompany;

    @Schema(description = "파손 부위")
    String part;
    @Schema(description = "파손 종류")
    String damage;
    @Schema(description = "파손 날짜")
    Date damageDate;
    @Schema(description = "파손 사진 URL")
    String damageImageUrl;
    @Schema(description = "파손 기록")
    String memo;

    @Builder
    public RentDetailResponse(Long carId, String carNumber, String carManufacturer, String carModel, String carFuel, LocalDateTime rentalDate, LocalDateTime returnDate, String rentalCompany, String part, String damage, Date damageDate, String damageImageUrl, String memo) {
        this.carId = carId;
        this.carNumber = carNumber;
        this.carManufacturer = carManufacturer;
        this.carModel = carModel;
        this.carFuel = carFuel;
        this.rentalDate = rentalDate;
        this.returnDate = returnDate;
        this.rentalCompany = rentalCompany;
        this.part = part;
        this.damage = damage;
        this.damageDate = damageDate;
        this.damageImageUrl = damageImageUrl;
        this.memo = memo;
    }
}
