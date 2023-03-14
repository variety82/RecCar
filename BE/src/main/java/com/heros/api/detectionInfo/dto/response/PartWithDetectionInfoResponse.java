package com.heros.api.detectionInfo.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Data
@Schema(description = "차량 파손 정보.")
public class PartWithDetectionInfoResponse {
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
    public PartWithDetectionInfoResponse(String part, String damage,  Date damageDate, String damageImageUrl, String memo) {
        this.part = part;
        this.damage = damage;
        this.damageDate = damageDate;
        this.damageImageUrl = damageImageUrl;
        this.memo = memo;
    }
}
