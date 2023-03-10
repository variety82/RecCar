package com.heros.api.user.entity;


import com.heros.api.car.entity.Car;
import lombok.*;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "USER")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "USER_ID", columnDefinition = "INT UNSIGNED")
    private Long userId;

    @Column(name = "UID")
    private String UId;

    @Column(name = "NICKNAME", length = 10)
    private String nickName;

    @Column(name = "PICTURE")
    private String picture;

    @Column(name = "EMAIL", length = 50)
    private String email;

    @OneToMany(mappedBy = "user")
    private List<Car> cars = new ArrayList<>();

    @Builder
    public User(
            @NotNull Long userId,
            String UId,
            String nickName,
            String picture,
            String email
    ){
        this.UId = UId;
        this.nickName = nickName;
        this.picture = picture;
        this.email = email;
    }

    public void updateCar(Car car){
        this.cars.add(car);
    }
}
