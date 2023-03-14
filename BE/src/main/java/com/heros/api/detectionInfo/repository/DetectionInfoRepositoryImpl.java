package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.detectionInfo.dto.response.RentDetailResponse;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


import java.util.List;

import static com.heros.api.car.entity.QCar.car;
import static com.heros.api.detectionInfo.entity.QDetectionInfo.detectionInfo;

@Slf4j
@RequiredArgsConstructor
public class DetectionInfoRepositoryImpl implements DetectionInfoRepositorySupport{
    private final JPAQueryFactory queryFactory;
    @Override
    public PartWithDetectionInfoResponse getDetectionInfos(Long carId){
        PartWithDetectionInfoResponse result = queryFactory
                .select(Projections.constructor(PartWithDetectionInfoResponse.class,
                        detectionInfo.part,
                        detectionInfo.damage,
                        detectionInfo.damageDate,
                        detectionInfo.damageImageUrl,
                        detectionInfo.memo))
                .from(detectionInfo)
                .where(detectionInfo.car.carId.eq(carId))
                .fetchOne();
        log.info("DetectionInfo : {result}");
        return result;
    }


    @Override
    public RentDetailResponse getRentalDetailInfos(Long carId) {
        RentDetailResponse result = queryFactory
                .select(Projections.constructor(RentDetailResponse.class,
                        car.carId,
                        car.carNumber,
                        car.carManufacturer,
                        car.carModel,
                        car.carFuel,
                        car.rentalDate,
                        car.returnDate,
                        car.rentalCompany,
                        detectionInfo.part,
                        detectionInfo.damage,
                        detectionInfo.damageDate,
                        detectionInfo.damageImageUrl,
                        detectionInfo.memo))
                .from(detectionInfo)
                .where(detectionInfo.car.carId.eq(carId))
                .fetchOne();
        log.info("RentalDetail : {result}");
        return result;
    }
}
