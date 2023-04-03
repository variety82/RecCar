package com.heros.api.detectionInfo.service;

import com.heros.api.car.entity.Car;
import com.heros.api.car.repository.CarRepository;
import com.heros.api.detectionInfo.dto.request.DetectionInfoCreate;
import com.heros.api.detectionInfo.dto.response.CarDetectionResponse;
import com.heros.api.detectionInfo.dto.response.CarDetectionResponse2;
import com.heros.api.detectionInfo.entity.DetectionInfo;
import com.heros.api.detectionInfo.repository.DetectionInfoRepository;
import com.heros.api.user.entity.User;
import com.heros.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class DetectionInfoService {

    private final DetectionInfoRepository detectionInfoRepository;
    private final CarRepository carRepository;
    private final UserRepository userRepository;

    public CarDetectionResponse getRentDetailInfos(Long carId){
        Car car = carRepository.findById(carId).get();
        List<DetectionInfo> detectionInfos = detectionInfoRepository.findByCar(car);
        List<DetectionInfo> initialDetectionInfos = new ArrayList<>();
        List<DetectionInfo> latterDetectionInfos = new ArrayList<>();
        for (DetectionInfo detectionInfo:detectionInfos) {
            if (detectionInfo.isFormer())
                initialDetectionInfos.add(detectionInfo);
            else
                latterDetectionInfos.add(detectionInfo);
        }
        return new CarDetectionResponse(car, initialDetectionInfos, latterDetectionInfos);
    }

    public CarDetectionResponse2 getRentDetailInfos2(Long carId){
        List<String> parts = Arrays.asList("front", "side", "back", "wheel");
        Car car = carRepository.findById(carId).get();
        List<DetectionInfo> detectionInfos = detectionInfoRepository.findByCar(car);
        Map<String, List<DetectionInfo>> initialDetectionInfos = new HashMap<>();
        Map<String, List<DetectionInfo>> latterDetectionInfos = new HashMap<>();
        for (String part:parts) {
            initialDetectionInfos.put(part, new ArrayList<>());
            latterDetectionInfos.put(part, new ArrayList<>());
        }
        for (DetectionInfo detectionInfo:detectionInfos) {
            String part = detectionInfo.getPart();
            if (detectionInfo.isFormer())
                initialDetectionInfos.get(part).add(detectionInfo);
            else
                latterDetectionInfos.get(part).add(detectionInfo);
        }
        return new CarDetectionResponse2(car, initialDetectionInfos, latterDetectionInfos);
    }

    @Transactional
    public void createDamageInfo(List<DetectionInfoCreate> detectionInfoCreates, User user){
        Car car = carRepository.findById(detectionInfoCreates.get(0).getCarId()).orElseThrow(IllegalArgumentException::new);
        Boolean former = detectionInfoCreates.get(0).isFormer();
        int[] damages = new int[4];
        for (DetectionInfoCreate detectionInfoCreate : detectionInfoCreates) {
            int damage = detectionInfoCreate.getScratch() + detectionInfoCreate.getBreakage() +detectionInfoCreate.getCrushed() + detectionInfoCreate.getSeparated();
            if (detectionInfoCreate.getPart().equals("front")) {
                damages[0] += damage;
            }
            else if (detectionInfoCreate.getPart().equals("side")) {
                damages[1] += damage;
            }
            else if (detectionInfoCreate.getPart().equals("back")) {
                damages[2] += damage;
            }
            else if (detectionInfoCreate.getPart().equals("wheel")) {
                damages[3] += damage;
            }
            DetectionInfo detectionInfo =  DetectionInfo.builder()
                    .car(car)
                    .former(detectionInfoCreate.isFormer())
                    .damageImageUrl(detectionInfoCreate.getPictureUrl())
                    .part(detectionInfoCreate.getPart())
                    .scratch(detectionInfoCreate.getScratch())
                    .crushed(detectionInfoCreate.getCrushed())
                    .breakage(detectionInfoCreate.getBreakage())
                    .separated(detectionInfoCreate.getSeparated())
                    .memo(detectionInfoCreate.getMemo())
                    .damageDate(detectionInfoCreate.getDamageDate())
                    .build();
            detectionInfoRepository.save(detectionInfo);
        }
        car.setDamageCount(former, damages);
        user.updateCurrentCarVideo();
        userRepository.save(user);
    }
}
