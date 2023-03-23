package com.heros.api.car.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class CarCatalogResponse {
    @Schema(description = "제조사", example = "현대")
    String manufacturer;

    @Schema(description = "모델", example = "[쏘나타, 아반떼]")
    List<String> model;

    @Builder
    public CarCatalogResponse(String manufacturer, List<String> model) {
        this.manufacturer = manufacturer;
        this.model = model;
    }
}
