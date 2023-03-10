package com.heros.api.example.model;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

@Schema(description = "모델 설명 입니다.")
@Getter
@Setter
public class UserValue {
    @Schema(description = "이름", example = "김싸피")
    private String name;

    @DateTimeFormat(pattern = "yyMMdd")
    @Schema(description = "생년월일", example = "yyMMdd", maxLength = 6)
    private String birthDate;

    @Override
    public String toString() {
        return "UserValue{" +
                "name='" + name + '\'' +
                ", birthDate='" + birthDate + '\'' +
                '}';
    }
}