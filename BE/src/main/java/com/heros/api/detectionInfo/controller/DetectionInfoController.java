package com.heros.api.detectionInfo.controller;


import com.heros.api.detectionInfo.dto.request.DetectionInfoCreate;
import com.heros.api.detectionInfo.dto.response.PartWithDetectionInfoResponse;
import com.heros.api.detectionInfo.dto.response.RentDetailResponse;
import com.heros.api.detectionInfo.entity.DetectionInfo;
import com.heros.api.detectionInfo.service.DetectionInfoService;
import com.heros.api.example.model.ErrorResponseExample;
import com.heros.exception.ErrorCode;
import com.heros.exception.customException.BusinessException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.repository.query.Param;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Optional;

@Tag(name = "DetectionInfoController", description = "차량 파손 정보 API")
@RestController
@RequiredArgsConstructor
public class DetectionInfoController {

    private final DetectionInfoService detectionInfoService;

    @Operation(summary = "차량파손정보상세")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = PartWithDetectionInfoResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "/api/v1/detection/{detectionInfoId}")
    public ResponseEntity<?> getDetectionInfoDetail(@Schema(description = "조회할 detectionInfoId", example = "1") @NotNull @Min(1) @PathVariable Long detectionInfoId){
        Optional<DetectionInfo> detectionInfoDetail = detectionInfoService.getDetectionInfoDetail(detectionInfoId);
        if (detectionInfoDetail == null) {
            throw (new BusinessException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.ok().body(detectionInfoDetail);
    }

    @Operation(summary = "차량파손정보")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = PartWithDetectionInfoResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "/api/v1/detection")
    public ResponseEntity<?> getDetectionInfos(@NotNull @Min(1) @Param(value = "carId") Long carId){
        List<PartWithDetectionInfoResponse> detectionInfos = detectionInfoService.getDetectionInfos(carId);

        if (detectionInfos.size() == 0) {
            throw (new BusinessException(ErrorCode.PAGE_NOT_FOUND));
        }

        return ResponseEntity.ok().body(detectionInfos);
    }

    @Operation(summary = "렌트 내역 상세 조회")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = RentDetailResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "/api/v1/detection/rental")
    public ResponseEntity<?> getRentDetailInfos(@NotNull @Min(1) @Param(value = "carId") Long carId){
        RentDetailResponse rentalDetailInfos = detectionInfoService.getRentDetailInfos(carId);
        if (rentalDetailInfos == null) {
            throw (new BusinessException(ErrorCode.PAGE_NOT_FOUND));
        }

        return ResponseEntity.ok().body(rentalDetailInfos);
    }

    @Operation(summary = "파손 정보 등록")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = DetectionInfoCreate.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @PostMapping(value = "/api/v1/detection")
    public ResponseEntity<?> addDetectionInfo(@Valid @RequestBody DetectionInfoCreate detectionInfoCreate) {
        detectionInfoService.createDamageInfo(detectionInfoCreate);
        return ResponseEntity.status(201).body(null);
    }
}
