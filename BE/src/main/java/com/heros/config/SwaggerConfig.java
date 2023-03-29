package com.heros.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// SwaggerConfig.java
//@OpenAPIDefinition(
//        info = @Info(title = "swagger 제목",
//                description = "swagger 설명",
//                version = "버젼"))
@RequiredArgsConstructor
@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI openAPI() {

        Info info = new Info()
                .version("버전 입력")
                .title("Swagger 타이틀 입력")
                .description("Swagger Description");

        // SecuritySecheme명
        String jwtSchemeName = "accessToken";
        // API 요청헤더에 인증정보 포함
        SecurityRequirement securityRequirement = new SecurityRequirement().addList(jwtSchemeName);
        // SecuritySchemes 등록
        Components components = new Components()
                .addSecuritySchemes(jwtSchemeName, new SecurityScheme()
                        .name(jwtSchemeName)
                        .type(SecurityScheme.Type.HTTP) // HTTP 방식
                        .scheme("bearer")
                        .bearerFormat("")); // 토큰 형식을 지정하는 임의의 문자(Optional)

        return new OpenAPI()
                .info(info)
                .addSecurityItem(securityRequirement)
                .components(components);
    }

//    모든 api 공통 인자 설정하는 방법
//    @Bean
//    public OperationCustomizer operationCustomizer() {
//        return (Operation operation, HandlerMethod handlerMethod) -> {
//            Parameter param = new Parameter()
//                    .in(ParameterIn.HEADER.toString())  // 전역 헤더 설정
//                    .name("accessToken")
//                    .description("google login을 통해 얻어온 token")
//                    .required(true);
//            operation.addParametersItem(param);
//            return operation;
//        };
//    }

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
