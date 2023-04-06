package com.heros.common;

import com.heros.api.user.entity.User;
import com.heros.api.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RequiredArgsConstructor
@Component
public class LoginInterceptor implements HandlerInterceptor {
    private final UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 어떤 요청이 들어왔는지 확인
        String url = request.getRequestURI();
        System.out.println("interceptor api uri : " + url);

        // swagger 처리
        if (url.contains("swagger") || url.contains("api-docs") || url.contains("webjars")) {
            return true;
        }
        // 유저 토큰 발급용
        if (url.equals("/api/v1/user/login"))
            return true;

        String accessToken = request.getHeader("accessToken");
        // swagger header 토큰 받기
        if (accessToken == null)
            accessToken = request.getHeader("Authorization").replaceAll("Bearer ", "");
        System.out.println("token : "+accessToken);

        User user = userService.loginUser(accessToken);
        if (user == null)
            return false;
        System.out.println(user);
        request.setAttribute("user", user);
        System.out.println("interceptor quit");
        return true;
    }
}