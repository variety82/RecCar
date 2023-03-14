package com.heros.api.car.controller;

import com.heros.api.car.dto.request.CarCreate;
import com.heros.api.car.dto.request.CarModify;
import com.heros.api.car.dto.response.CarResponse;
import com.heros.api.car.service.CarService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/car/")
@Tag(name = "Car-Api", description = "Car-Api 입니다.")
public class CarController {
    private final CarService carService;
    @Operation(summary = "차량 등록", description = "차량 등록 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "차량 등록 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PostMapping(value = "")
    public ResponseEntity<?> carAdd(@RequestBody CarCreate carCreate) {
        carService.createCar(carCreate);
        return ResponseEntity.status(201).body(null);
    }

    @Operation(summary = "차량 수정", description = "차량 수정 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "차량 수정 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PutMapping(value = "")
    public ResponseEntity<?> carModify(@RequestBody CarModify carModify) {
        carService.modifyCar(carModify);
        return ResponseEntity.status(201).body(carModify);
    }

    @Operation(summary = "차량 리스트 조회", description = "userId의 차량 리스트 조회 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "차량 리스트 조회 성공", content = @Content(schema = @Schema(implementation = CarResponse.class))),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PostMapping(value = "history")
    public ResponseEntity<?> carListGet(@Schema(description = "조회할 userId", example = "1") @RequestBody Long userId) {
        List<CarResponse> carList = carService.findCarList(userId);
        return ResponseEntity.status(200).body(carList);
    }
}
