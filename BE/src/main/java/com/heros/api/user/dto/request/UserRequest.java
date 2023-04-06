package com.heros.api.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserRequest {
    @Schema(description = "nickName", example = "taekun")
    private String nickName;
    @Schema(description = "userId", example = "1")
    private String picture;

    @Override
    public String toString() {
        return "UserResponse{" +
                "nickName='" + nickName + '\'' +
                ", picture='" + picture + '\'' +
                '}';
    }
}
