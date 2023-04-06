package com.heros.api.example.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.heros.api.example.model.ErrorResponseExample;
import com.heros.api.example.model.GoogleOAuthToken;
import com.heros.api.example.model.UserValue;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.*;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Tag(name = "api example", description = "api 예시 입니다.")
@RestController
@RequestMapping("/api/login/")
public class loginExampleController {
    private ObjectMapper objectMapper = new ObjectMapper();

    //    https://localhost:8080/#access_token=ya29.a0Ael9sCPXXUwOkKVXLFts9kRzT7VClLHdaBB6-tNOPpXqepJ_xHp-p8gvMlpfajrVsrI2DHErBYXiEBDM41q-GKNW8YlbhFef4NvkwKO93kXc55hKtjTiShXDbxANIXmmKuTLeE2-VOYIL_mdQ7FtEmuRRKMsaCgYKAQISARASFQF4udJhU2cA5IPxV-4z85n47n5apg0163&token_type=Bearer&expires_in=3599&scope=email%20openid%20https://www.googleapis.com/auth/userinfo.email&authuser=0&hd=ajou.ac.kr&prompt=none
    @Operation(summary = "예시 메서드", description = "예시 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/google")
    public void login(HttpServletResponse response) throws Exception{
        response.sendRedirect(getOauthRedirectURL());
    }
    @Operation(summary = "예시 메서드", description = "예시 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/callback")
    public ResponseEntity<?> callback(@RequestParam(name = "code") String code) throws IOException {
        System.out.println(code);
        String accessToken = oAuthLogin(code);
        return ResponseEntity.ok().body(accessToken);
    }

    @Operation(summary = "예시 메서드", description = "예시 메서드입니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation"),
            @ApiResponse(responseCode = "400", description = "bad request operation")
    })
    @GetMapping(value = "/userInfo")
    public ResponseEntity<?> userInfo(@RequestHeader("access-token") String accessToken) {
        System.out.println(accessToken);
        String url = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=" + accessToken;
        HttpHeaders headers = new HttpHeaders();
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity(headers);
        ResponseEntity<String> response=new RestTemplate().exchange(url, HttpMethod.GET,request,String.class);
        System.out.println("response.getBody() = " + response.getBody());
        return ResponseEntity.ok().body(null);
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

    public String getOauthRedirectURL(){

        Map<String,Object> params=new HashMap<>();
        params.put("scope","https://www.googleapis.com/auth/userinfo.email");
        params.put("response_type","code");
        params.put("client_id","993410709622-geh083urrsjc4en7oajal6ugv39njo36.apps.googleusercontent.com");
//        params.put("redirect_uri","http://localhost:8080/api/login/callback");
        params.put("redirect_uri","http://j8a102.p.ssafy.io:8080/api/login/callback");

        //parameter를 형식에 맞춰 구성해주는 함수
        String parameterString=params.entrySet().stream()
                .map(x->x.getKey()+"="+x.getValue())
                .collect(Collectors.joining("&"));
        String redirectURL="https://accounts.google.com/o/oauth2/v2/auth"+"?"+parameterString;
        System.out.println("redirectURL = " + redirectURL);

        return redirectURL;
        /*
         * https://accounts.google.com/o/oauth2/v2/auth?scope=profile&response_type=code
         * &client_id="할당받은 id"&redirect_uri="access token 처리")
         * 로 Redirect URL을 생성하는 로직을 구성
         * */
    }

    public String oAuthLogin(String code) throws IOException {
        //구글로 일회성 코드를 보내 액세스 토큰이 담긴 응답객체를 받아옴
        ResponseEntity<String> accessTokenResponse= requestAccessToken(code);
        System.out.println("1111111111111111111111111111111111");
        //응답 객체가 JSON형식으로 되어 있으므로, 이를 deserialization해서 자바 객체에 담을 것이다.
        GoogleOAuthToken oAuthToken=getAccessToken(accessTokenResponse);
        System.out.println(oAuthToken.getAccess_token());
        System.out.println("---------------------------------");
        //액세스 토큰을 다시 구글로 보내 구글에 저장된 사용자 정보가 담긴 응답 객체를 받아온다.
//        ResponseEntity<String> userInfoResponse=requestUserInfo(oAuthToken);
//        System.out.println("=================================");
//        //다시 JSON 형식의 응답 객체를 자바 객체로 역직렬화한다.
//        GoogleUser googleUser= getUserInfo(userInfoResponse);
//        System.out.println(googleUser);
        return oAuthToken.getAccess_token();
    }

    public ResponseEntity<String> requestAccessToken(String code) {
        String GOOGLE_TOKEN_REQUEST_URL="https://oauth2.googleapis.com/token";
        RestTemplate restTemplate=new RestTemplate();
        Map<String, Object> params = new HashMap<>();
        params.put("code", code);
        params.put("client_id", "993410709622-geh083urrsjc4en7oajal6ugv39njo36.apps.googleusercontent.com");
        params.put("client_secret", "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");
//        params.put("redirect_uri", "http://localhost:8080/api/login/callback");
        params.put("redirect_uri","http://j8a102.p.ssafy.io:8080/api/login/callback");
        params.put("grant_type", "authorization_code");

        ResponseEntity<String> responseEntity=restTemplate.postForEntity(GOOGLE_TOKEN_REQUEST_URL,
                params,String.class);

        if(responseEntity.getStatusCode()== HttpStatus.OK){
            return responseEntity;
        }
        return null;
    }

    public GoogleOAuthToken getAccessToken(ResponseEntity<String> response) throws JsonProcessingException {
        System.out.println("response.getBody() = " + response.getBody());
        GoogleOAuthToken googleOAuthToken= objectMapper.readValue(response.getBody(),GoogleOAuthToken.class);
        return googleOAuthToken;
    }

//    public ResponseEntity<String> requestUserInfo(GoogleOAuthToken oAuthToken) {
//        String GOOGLE_USERINFO_REQUEST_URL="https://www.googleapis.com/oauth2/v1/userinfo";
//
//        //header에 accessToken을 담는다.
//        HttpHeaders headers = new HttpHeaders();
//        headers.add("Authorization","Bearer "+oAuthToken.getAccess_token());
//
//        //HttpEntity를 하나 생성해 헤더를 담아서 restTemplate으로 구글과 통신하게 된다.
//        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity(headers);
//        ResponseEntity<String> response=new RestTemplate().exchange(GOOGLE_USERINFO_REQUEST_URL, HttpMethod.GET,request,String.class);
//        System.out.println("response.getBody() = " + response.getBody());
//        return response;
//    }

//    public GoogleUser getUserInfo(ResponseEntity<String> userInfoRes) throws JsonProcessingException{
//        GoogleUser googleUser=objectMapper.readValue(userInfoRes.getBody(),GoogleUser.class);
//        return googleUser;
//    }
}