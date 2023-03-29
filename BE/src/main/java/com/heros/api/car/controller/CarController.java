package com.heros.api.car.controller;

import com.heros.api.car.dto.request.CarCreate;
import com.heros.api.car.dto.request.CarModify;
import com.heros.api.car.dto.response.CarCatalogResponse;
import com.heros.api.car.dto.response.CarResponse;
import com.heros.api.car.service.CarService;
import com.heros.api.user.entity.User;
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
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        Long carId = carService.createCar(carCreate, user);
        return ResponseEntity.status(201).body(carId);
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
        return ResponseEntity.status(201).body(carService.modifyCar(carModify));
    }

    @Operation(summary = "차량 리스트 조회", description = "현재 로그인된 user의 차량 리스트 조회 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "차량 리스트 조회 성공", content = @Content(schema = @Schema(implementation = CarResponse.class))),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "history")
    public ResponseEntity<?> carListGet() {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        List<CarResponse> carList = carService.findCarList(user);
        if (carList.size() == 0) {
            throw (new BusinessException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.status(200).body(carList);
    }

    @Operation(summary = "대여중인 차량 조회", description = "현재 로그인된 user의 대여중인 차량 조회 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "대여중인 차량 조회 성공", content = @Content(schema = @Schema(implementation = CarResponse.class))),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/")
    public ResponseEntity<?> carGet() {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        CarResponse carResponse = carService.findCar(user);
        if (carResponse == null) {
            throw (new CarException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.status(200).body(carResponse);
    }

    @Operation(summary = "대여중인 차량 반납", description = "현재 로그인된 user의 대여중인 차량 반납 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "대여중인 차량 반납 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/return")
    public ResponseEntity<?> carReturn() {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        CarResponse carResponse = carService.returnCar(user);
        if (carResponse == null) {
            throw (new CarException(ErrorCode.PAGE_NOT_FOUND));
        }
        return ResponseEntity.status(200).body(carResponse);
    }

    @Operation(summary = "차량 삭제", description = "carId를 이용한 차량 삭제 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "차량 삭제 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @DeleteMapping(value = "/{carId}")
    public ResponseEntity<?> carDelete(@PathVariable("carId") Long carId) {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        carService.deleteCar(carId);
        return ResponseEntity.status(200).body(null);
    }
}
