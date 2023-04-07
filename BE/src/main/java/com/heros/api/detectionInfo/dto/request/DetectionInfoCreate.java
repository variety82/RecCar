package com.heros.api.detectionInfo.dto.request;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.sql.Date;

@Data
@Schema(description = "차량 파손 정보 등록 request.")
public class DetectionInfoCreate {
    @Schema(description = "차량 PK", example = "1")
    @NotNull
    @Min(1)
    Long carId;

    @Schema(description = "등록 전/후 여부", example = "false")
    boolean former;

    @Schema(description = "파손 사진 URL", example = "http://sample.sample")
    @NotBlank
    String pictureUrl;

    @Schema(description = "파손 부위", example = "front")
    @NotBlank
    String part;

    @Schema(description = "파손 메모", example = "아이고 여기 상처가..!")
    String memo;

    @Schema(description = "파손 날짜", example = "2023-03-12T16:34:30.388")
    @NotNull
    Date damageDate;

    @Schema(description = "scratch 개수", example = "3")
    int scratch;

    @Schema(description = "breakage 개수", example = "3")
    int breakage;

    @Schema(description = "crushed 개수", example = "3")
    int crushed;

    @Schema(description = "separated 개수", example = "3")
    int separated;
}
