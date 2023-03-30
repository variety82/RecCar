package com.heros.api.user.dto.response;

import com.heros.api.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserLoginResponse {
    @Schema(description = "nickName", example = "taekun")
    private String nickName;
    @Schema(description = "picture", example = "profile.jpg")
    private String picture;
    @Schema(description = "currentCarId", example = "1")
    private Long currentCarId;
    @Schema(description = "accessToken", example = "ya29.a0Ael9sCPo1lWNn")
    private String accessToken;
    public UserLoginResponse(User user, String accessToken) {
        this.nickName = user.getNickName();
        this.picture = user.getPicture();
        this.currentCarId = user.getCurrentCarId();
        this.accessToken = accessToken;
    }

    @Override
    public String toString() {
        return "UserResponse{" +
                "nickName='" + nickName + '\'' +
                ", picture='" + picture + '\'' +
                '}';
    }
}
