package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.detectionInfo.dto.response.RentDetailResponse;

import java.util.List;


public interface DetectionInfoRepositorySupport {
    List<PartWithDetectionInfoResponse> getDetectionInfos(Long carId);
    RentDetailResponse getRentalDetailInfos(Long carId);
}
