package com.heros.api.detectionInfo.service;

import com.heros.api.car.entity.Car;
import com.heros.api.car.repository.CarRepository;
import com.heros.api.detectionInfo.dto.request.DetectionInfoCreate;
import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.detectionInfo.dto.response.RentDetailResponse;
import com.heros.api.detectionInfo.entity.DetectionInfo;
import com.heros.api.detectionInfo.repository.DetectionInfoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class DetectionInfoService {

    private final DetectionInfoRepository detectionInfoRepository;
    private final CarRepository carRepository;
    public List<PartWithDetectionInfoResponse> getDetectionInfos(Long carId){
        List<PartWithDetectionInfoResponse> detectionInfos = detectionInfoRepository.getDetectionInfos(carId);
        return detectionInfos;
    }

    public RentDetailResponse getRentDetailInfos(Long carId){
        RentDetailResponse rentDetailInfos = detectionInfoRepository.getRentalDetailInfos(carId);
        return rentDetailInfos;
    }

    @Transactional
    public void createDamageInfo(DetectionInfoCreate detectionInfoCreate){
        Car car = carRepository.findById(detectionInfoCreate.getCarId()).orElseThrow(IllegalArgumentException::new);
        DetectionInfo detectionInfo =  DetectionInfo.builder()
                .car(car)
                .former(detectionInfoCreate.isFormer())
                .damageImageUrl(detectionInfoCreate.getPictureUrl())
                .part(detectionInfoCreate.getPart())
                .damage(detectionInfoCreate.getDamage())
                .memo(detectionInfoCreate.getMemo())
                .damageDate(detectionInfoCreate.getDamageDate())
                .build();
        detectionInfoRepository.save(detectionInfo);
    }
}
