package com.heros.api.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.heros.api.example.model.GoogleOAuthToken;
import com.heros.api.user.dto.request.UserRequest;
import com.heros.api.user.dto.response.UserLoginResponse;
import com.heros.api.user.dto.response.UserResponse;
import com.heros.api.user.entity.User;
import com.heros.api.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/user")
@Validated
@Tag(name = "User-Api", description = "User-Api 입니다.")
public class UserController {
    private final UserService userService;
    private ObjectMapper objectMapper = new ObjectMapper();
    @Operation(summary = "유저 로그인", description = "유저 로그인 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "유저 로그인 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/login")
    public ResponseEntity<?> login(@RequestParam(name = "code") String code) throws Exception {
        String GOOGLE_TOKEN_REQUEST_URL="https://oauth2.googleapis.com/token";
        RestTemplate restTemplate=new RestTemplate();
        Map<String, Object> params = new HashMap<>();
        params.put("code", code);
        params.put("client_id", "993410709622-geh083urrsjc4en7oajal6ugv39njo36.apps.googleusercontent.com");
        params.put("client_secret", "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");
//        params.put("redirect_uri", "http://localhost:8080/api/v1/user/login");
        params.put("redirect_uri","http://j8a102.p.ssafy.io:8080/api/v1/user/login");
        params.put("grant_type", "authorization_code");
        ResponseEntity<String> responseEntity=restTemplate.postForEntity(GOOGLE_TOKEN_REQUEST_URL, params, String.class);
        String accessToken = objectMapper.readValue(responseEntity.getBody(),GoogleOAuthToken.class).getAccess_token();
        System.out.println(accessToken);

        User user = userService.loginUser(accessToken);
        System.out.println(user);
        return ResponseEntity.status(200).body(new UserLoginResponse(user, accessToken));
    }

    @Operation(summary = "유저 로그인", description = "유저 로그인 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "유저 로그인 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PostMapping(value = "/tokenLogin")
    public ResponseEntity<?> login() {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");
        return ResponseEntity.status(200).body(new UserResponse(user));
    }


    //    @Operation(summary = "access-token 받기", description = "access-token 메서드입니다.")
//    @ApiResponses(value = {
//            @ApiResponse(responseCode = "201", description = "access-token 발급 성공"),
//            @ApiResponse(responseCode = "400", description = "bad request operation")
//    })
    @GetMapping(value = "/token")
    public ResponseEntity<?> token(String code) {
        String GOOGLE_TOKEN_REQUEST_URL="https://oauth2.googleapis.com/token";
        RestTemplate restTemplate=new RestTemplate();
        Map<String, Object> params = new HashMap<>();
        params.put("code", code);
        params.put("client_id", "993410709622-geh083urrsjc4en7oajal6ugv39njo36.apps.googleusercontent.com");
        params.put("client_secret", "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");
        params.put("redirect_uri", "http://localhost:8080/api/v1/user/token");
        params.put("grant_type", "authorization_code");

        ResponseEntity<String> responseEntity=restTemplate.postForEntity(GOOGLE_TOKEN_REQUEST_URL, params, String.class);
        System.out.println("response.getBody() = " + responseEntity.getBody());
        return ResponseEntity.status(201).body(responseEntity.getBody());
    }

    @Operation(summary = "User 수정", description = "유저 수정 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "202", description = "유저 수정 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @PatchMapping(value = "/modify")
    public ResponseEntity<?> userModify(UserRequest userRequest) {
        System.out.println("userModifyInput : " + userRequest.toString());

        // acccess token을 통해 db에서 불러온 user
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        User user = (User) httpServletRequest.getAttribute("user");

        UserResponse returnUser = userService.modifyUser(user, userRequest);
        return ResponseEntity.status(201).body(returnUser);
    }

    @Operation(summary = "User 삭제", description = "유저 삭제 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "202", description = "유저 삭제 성공"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @DeleteMapping(value = "/delete")
    public ResponseEntity<?> userDelete() {
        HttpServletRequest httpServletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        userService.deleteUser((User) httpServletRequest.getAttribute("user"));
        return ResponseEntity.status(202).body(null);
    }
}
