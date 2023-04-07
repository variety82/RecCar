package com.heros.api.detectionInfo.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.heros.api.car.entity.Car;
import lombok.*;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "DETECTION_INFO")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class DetectionInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "DETECTION_INFO_ID", columnDefinition = "INT UNSIGNED")
    private Long detectionInfoId;

    @Column(name = "PART", length = 50)
    private String part;

    @Column(name = "DAMAGE_DATE")
    private Date damageDate;

    @Column(name = "MEMO")
    private String memo;

    @Column(name = "DAMAGE_IMAGE_URL")
    private String damageImageUrl;

    @Column(name = "FORMER", columnDefinition="tinyint(1)")
    private boolean former;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CAR_ID")
    @JsonIgnore
    private Car car;

    @Column(name = "scratch")
    private int scratch;

    @Column(name = "breakage")
    private int breakage;

    @Column(name = "crushed")
    private int crushed;

    @Column(name = "separated")
    private int separated;

    @Builder
    public DetectionInfo(Long detectionInfoId, String part, Date damageDate, String memo, String damageImageUrl, boolean former, Car car, int scratch, int breakage, int crushed, int separated) {
        this.detectionInfoId = detectionInfoId;
        this.part = part;
        this.damageDate = damageDate;
        this.memo = memo;
        this.damageImageUrl = damageImageUrl;
        this.former = former;
        this.car = car;
        this.scratch = scratch;
        this.breakage = breakage;
        this.crushed = crushed;
        this.separated = separated;
    }
}
