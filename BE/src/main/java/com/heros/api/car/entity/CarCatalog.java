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

    @Column(name = "MAKE")
    private String make;

    @Column(name = "MODEL")
    private String model;

    @Column(name = "LOGO_URL")
    private String logoURL;

    @Builder
    public CarCatalog(String make, String model, String logoURL) {
        this.make = make;
        this.model = model;
        this.logoURL = logoURL;
    }
}
