package com.heros.api.example.controller;

import com.heros.api.example.model.ErrorResponseExample;
import com.heros.api.example.model.UserValue;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "api example", description = "api 예시 입니다.")
@RestController
@RequestMapping("/api/example/")
public class exampleController {

    @Operation(summary = "예시 메서드", description = "예시 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/{input}")
    public ResponseEntity<?> input(@PathVariable("input") String input) {
        System.out.println(input);
        return ResponseEntity.ok().body(input);
    }

    @Operation(summary = "예시 메서드2", description = "예시 메서드2입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "성공 설명", content = @Content(schema = @Schema(implementation = UserValue.class))),
            @ApiResponse(responseCode = "404", description = "실패 설명(이름이 없는 경우)", content = @Content(schema = @Schema(implementation = ErrorResponseExample.class)))
    })
    @PostMapping(value = "/login")
    public ResponseEntity<?> login(@RequestBody UserValue user) {
        System.out.println(user);
        if (user.getName() == null || user.getName().length() == 0)
            return ResponseEntity.badRequest().body(new ErrorResponseExample());
        return ResponseEntity.ok().body(user);
    }
}