package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.entity.DetectionInfo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DetectionInfoRepository extends JpaRepository<DetectionInfo, Long>, DetectionInfoRepositorySupport {
    @Override
    Optional<DetectionInfo> findById(Long aLong);
}
