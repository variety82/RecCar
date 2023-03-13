package com.heros.api.detectionInfo.service;

import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.detectionInfo.repository.DetectionInfoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class DetectionInfoService {

    private final DetectionInfoRepository detectionInfoRepository;
    public PartWithDetectionInfoResponse getDetectionInfos(Long carId){
        PartWithDetectionInfoResponse detectionInfos = detectionInfoRepository.getDetectionInfos(carId);
        return detectionInfos;
    }
}
