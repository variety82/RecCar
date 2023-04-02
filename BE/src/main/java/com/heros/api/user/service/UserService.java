package com.heros.api.user.service;

import com.heros.api.user.dto.request.UserRequest;
import com.heros.api.user.dto.response.UserResponse;
import com.heros.api.user.entity.User;
import com.heros.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Log4j2
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public User loginUser(String accessToken) {
        String googleUrl = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=" + accessToken;
        HttpHeaders headers = new HttpHeaders();
        HttpEntity<MultiValueMap<String, String>> googleRequest = new HttpEntity(headers);
        ResponseEntity<Map> googleResponse = new RestTemplate().exchange(googleUrl, HttpMethod.GET, googleRequest, Map.class);

        if (!(boolean)googleResponse.getBody().get("verified_email")) {
            System.out.println("부적절한 토큰");
            return null;
        }

        List<User> users = userRepository.findByUId((String)googleResponse.getBody().get("id"));

        User user = new User();
        if (users.size() == 0) {
            user.setUId((String)googleResponse.getBody().get("id"));
            user.setNickName((String)googleResponse.getBody().get("name"));
            user.setPicture((String)googleResponse.getBody().get("picture"));
            user.setCurrentCarId(0L);
            user.setCurrentCarVideo(0);
            user = userRepository.save(user);
        }
        else {
            user = users.get(0);
        }

        return user;
    }

    public UserResponse modifyUser(User user, UserRequest userRequest) {
        user.updateUser(userRequest);
        return new UserResponse(userRepository.save(user));
    }

    public void deleteUser(User user) {
        userRepository.delete(user);
    }
}
