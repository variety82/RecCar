package com.heros.api.example.model;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Schema(description = "에러 모델 설명 입니다.")
@Getter
@Setter
public class ErrorResponseExample {
    @Schema(description = "에러 메시지 설명", example = "error!")
    String errorMessage = "에러 메시지";
}
