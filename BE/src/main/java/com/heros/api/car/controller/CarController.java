package com.heros.api.car.controller;

import com.heros.api.car.dto.request.CarCreate;
import com.heros.api.car.dto.request.CarModify;
import com.heros.api.car.dto.response.CarCatalogResponse;
import com.heros.api.car.dto.response.CarResponse;
import com.heros.api.car.service.CarService;
import com.heros.exception.ErrorCode;
import com.heros.exception.customException.BusinessException;
import com.heros.exception.customException.CarException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/car/")
@Validated
@Tag(name = "Car-Api", description = "Car-Api 입니다.")
public class CarController {
    private final CarService carService;
    @Operation(summary = "차량 등록", description = "차량 등록 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "차량 등록 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PostMapping(value = "")
    public ResponseEntity<?> carAdd(@Valid @RequestBody CarCreate carCreate) {
        if (carCreate.getRentalDate().compareTo(carCreate.getReturnDate()) > 0) {
            throw (new CarException(ErrorCode.DATE_INPUT_INVALID));
        }
        carService.createCar(carCreate);
        return ResponseEntity.status(201).body(null);
    }

    @Operation(summary = "차량 제조사 및 모델 조회", description = "제조사 및 모델 조회 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "카탈로그 조회 성공 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "catalog")
    public ResponseEntity<?> carCatalog() {
        List<CarCatalogResponse> carCatalogResponse = carService.getCatalog();
        return ResponseEntity.status(201).body(carCatalogResponse);
    }

    @Operation(summary = "차량 수정", description = "차량 수정 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "차량 수정 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PutMapping(value = "")
    public ResponseEntity<?> carModify(@Valid @RequestBody CarModify carModify) {
        if (carModify.getRentalDate().compareTo(carModify.getReturnDate()) > 0) {
            throw (new CarException(ErrorCode.DATE_INPUT_INVALID));
        }
        carService.modifyCar(carModify);
        return ResponseEntity.status(201).body(carModify);
    }

    @Operation(summary = "차량 리스트 조회", description = "userId의 차량 리스트 조회 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "차량 리스트 조회 성공", content = @Content(schema = @Schema(implementation = CarResponse.class))),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "history/{userId}")
    public ResponseEntity<?> carListGet(@Schema(description = "조회할 userId", example = "1") @NotNull @Min(1) @PathVariable Long userId) {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        System.out.println("request : "+httpServletRequest.toString());
        System.out.println("request uid: "+httpServletRequest.getAttribute("UID"));
        List<CarResponse> carList = carService.findCarList(userId);
        if (carList.size() == 0) {
            throw (new BusinessException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.status(200).body(carList);
    }

    @Operation(summary = "대여중인 차량 조회", description = "userId의 대여중인 차량 조회 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "대여중인 차량 조회 성공", content = @Content(schema = @Schema(implementation = CarResponse.class))),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/{userId}")
    public ResponseEntity<?> carGet(@Schema(description = "조회할 userId", example = "1") @NotNull @Min(1) @PathVariable Long userId) {
        CarResponse carResponse = carService.findCar(userId);
        if (carResponse == null) {
            throw (new CarException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.status(200).body(carResponse);
    }
}
