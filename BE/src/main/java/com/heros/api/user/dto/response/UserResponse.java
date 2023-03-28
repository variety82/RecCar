package com.heros.api.user.dto.response;

import com.heros.api.user.entity.User;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserResponse {
    @Schema(description = "nickName", example = "taekun")
    private String nickName;
    @Schema(description = "userId", example = "1")
    private String picture;
    @Schema(description = "currentCarId", example = "1")
    private Long currentCarId;
    public UserResponse(User user) {
        this.nickName = user.getNickName();
        this.picture = user.getPicture();
        this.currentCarId = user.getCurrentCarId();
    }

    @Override
    public String toString() {
        return "UserResponse{" +
                "nickName='" + nickName + '\'' +
                ", picture='" + picture + '\'' +
                '}';
    }
}
