package com.heros.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;

// SwaggerConfig.java
@OpenAPIDefinition(
        info = @Info(title = "swagger 제목",
                description = "swagger 설명",
                version = "버젼"))
@RequiredArgsConstructor
@Configuration
public class SwaggerConfig {

//    여러개 그룹으로 설정할 때
//    @Bean
//    public GroupedOpenApi chatOpenApi() {
//        String[] paths = {"/api/v1/**"};
//
//        return GroupedOpenApi.builder()
//                .group("swagger API v1")
//                .pathsToMatch(paths)
//                .build();
//    }
}
