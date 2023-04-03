package com.heros.api.detectionInfo.repository;

import com.heros.api.car.entity.Car;
import com.heros.api.detectionInfo.entity.DetectionInfo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface DetectionInfoRepository extends JpaRepository<DetectionInfo, Long>{
    @Override
    Optional<DetectionInfo> findById(Long aLong);
    void deleteAllByCar(Car car);
    List<DetectionInfo> findByCar(Car car);
}
