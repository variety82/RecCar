package com.heros.api.detectionInfo.repository;

import com.heros.api.detectionInfo.entity.DetectionInfo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DetectionInfoRepository extends JpaRepository<DetectionInfo, Long>, DetectionInfoRepositorySupport {
}
