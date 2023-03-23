package com.heros.api.car.entity;


import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Table(name = "CAR_CATALOG")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CarCatalog {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "CATALOG_ID", columnDefinition = "INT UNSINGED")
    private Long catalogId;

    @JoinColumn(name = "MAKE")
    private String make;

    @JoinColumn(name = "MODEL")
    private String model;

    @Builder
    public CarCatalog(String make, String model) {
        this.make = make;
        this.model = model;
    }
}
