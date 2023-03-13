package com.heros.api.detectionInfo.dto.request;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Date;

@Data
@Schema(description = "차량 파손 정보 등록 request.")
public class DetectionInfoCreate {
    @Schema(description = "차량 PK")
    Long carId;
    @Schema(description = "등록 전/후 여부")
    boolean former;
    @Schema(description = "파손 사진 URL")
    String pictureUrl;
    @Schema(description = "파손 부위")
    String part;
    @Schema(description = "파손 종류")
    String damage;
    @Schema(description = "파손 메모")
    String memo;
    @Schema(description = "파손 날짜")
    Date damageDate;


}
