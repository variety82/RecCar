package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


import static com.heros.api.detectionInfo.entity.QDetectionInfo.detectionInfo;

@Slf4j
@RequiredArgsConstructor
public class DetectionInfoRepositoryImpl implements DetectionInfoRepositorySupport{
    private final JPAQueryFactory queryFactory;
    @Override
    public PartWithDetectionInfoResponse getDetectionInfos(Long carId){
        PartWithDetectionInfoResponse result = queryFactory
                .select(Projections.constructor(PartWithDetectionInfoResponse.class,
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
}
