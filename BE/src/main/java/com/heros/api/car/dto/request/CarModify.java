package com.heros.api.car.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CarModify {
    @Schema(description = "carId", example = "1", required = true)
    @NotNull
    @Min(1)
    private long carId;

    @Schema(description = "자동차 번호", example = "12삼 4567")
    @NotBlank
    private String carNumber;

    @Schema(description = "자동차 제조사", example = "현대")
    @NotBlank
    private String carManufacturer;

    @Schema(description = "자동차 모델명", example = "쏘나타")
    @NotBlank
    private String carModel;

    @Schema(description = "자동차 연료", example = "식용유")
    @NotBlank
    private String carFuel;

    @Schema(description = "빌린 날짜", example = "2019-11-12T16:34:30.388")
    @NotNull
    private LocalDateTime rentalDate;

    @Schema(description = "반납 날짜", example = "2019-11-12T16:34:30.388")
    @NotNull
    private LocalDateTime returnDate;

    @Schema(description = "렌탈 회사", example = "쏘카")
    @NotBlank
    private String rentalCompany;

}
