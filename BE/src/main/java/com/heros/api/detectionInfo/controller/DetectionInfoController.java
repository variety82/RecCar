package com.heros.api.detectionInfo.controller;


import com.heros.api.detectionInfo.dto.request.DetectionInfoCreate;
import com.heros.api.detectionInfo.dto.response.CarDetectionResponse;
import com.heros.api.detectionInfo.service.DetectionInfoService;
import com.heros.api.example.model.ErrorResponseExample;
import com.heros.api.user.entity.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.repository.query.Param;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.List;

@Tag(name = "DetectionInfoController", description = "차량 파손 정보 API")
@RestController
@RequiredArgsConstructor
public class DetectionInfoController {

    private final DetectionInfoService detectionInfoService;

    @Operation(summary = "차량 상세 정보 및 파손 정보 목록")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = CarDetectionResponse.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @GetMapping(value = "/api/v1/detection")
    public ResponseEntity<?> getDetectionInfos(@NotNull @Min(1) @Param(value = "carId") Long carId){
//        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
//        User user = (User) httpServletRequest.getAttribute("user");
        CarDetectionResponse carDetectionResponse = detectionInfoService.getRentDetailInfos(carId);
        return ResponseEntity.ok().body(carDetectionResponse);
    }

    @Operation(summary = "파손 정보 등록")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "success", content = @Content(schema = @Schema(implementation = DetectionInfoCreate.class))),
            @ApiResponse(responseCode = "404", description = "fail", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @PostMapping(value = "/api/v1/detection")
    public ResponseEntity<?> addDetectionInfo(@Valid @RequestBody List<DetectionInfoCreate> detectionInfoCreates) {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        detectionInfoService.createDamageInfo(detectionInfoCreates, user);
        return ResponseEntity.status(201).body(null);
    }
}
