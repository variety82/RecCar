package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.detectionInfo.dto.response.RentDetailResponse;


public interface DetectionInfoRepositorySupport {
    PartWithDetectionInfoResponse getDetectionInfos(Long carId);
    RentDetailResponse getRentalDetailInfos(Long carId);
}
