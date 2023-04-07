package com.heros.api.user.entity;


import com.heros.api.car.entity.Car;
import com.heros.api.user.dto.request.UserRequest;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "USER")
@Getter
@Setter
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "USER_ID", columnDefinition = "INT UNSIGNED")
    private Long userId;

    @Column(name = "UID")
    private String UId;

    @Column(name = "NICKNAME", length = 30)
    private String nickName;

    @Column(name = "PICTURE")
    private String picture;

    @Column(name = "CURRENT_CAR_ID")
    private Long currentCarId;

    @Column(name = "CURRENT_CAR_VIDEO")
    private int currentCarVideo;

    @OneToMany(mappedBy = "user")
    private List<Car> cars = new ArrayList<>();

    @Builder
    public User(
            @NotNull Long userId,
            String UId,
            String nickName,
            String picture
    ){
        this.UId = UId;
        this.nickName = nickName;
        this.picture = picture;
    }

    public void updateUser(UserRequest userRequest) {
        this.nickName = userRequest.getNickName();
        this.picture = userRequest.getPicture();
    }
    public void updateCar(Car car){
        this.cars.add(car);
    }
    public void updateCurrentCarVideo(){
        this.currentCarVideo += 1;
    }
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", UId='" + UId + '\'' +
                ", nickName='" + nickName + '\'' +
                ", picture='" + picture + '\'' +
                '}';
    }
}
