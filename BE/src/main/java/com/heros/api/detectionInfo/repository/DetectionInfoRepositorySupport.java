package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;


public interface DetectionInfoRepositorySupport {
    PartWithDetectionInfoResponse getDetectionInfos(Long carId);
}
