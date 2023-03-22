package com.heros.api.car.repository;

import com.heros.api.car.dto.response.CarCatalogResponse;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.heros.api.car.entity.QCarCatalog.carCatalog;

@Slf4j
@RequiredArgsConstructor
public class CarRepositoryImpl implements CarRepositorySupport{

    private final JPAQueryFactory queryFactory;

    @Override
    public List<CarCatalogResponse> getCatalog() {
        List<String> fetch = queryFactory.select(
                        carCatalog.make
                )
                .from(carCatalog)
                .groupBy(carCatalog.make)
                .fetch();
        System.out.println(Arrays.toString(fetch.toArray()));

        List<CarCatalogResponse> result = new ArrayList<>();
        for (String make : fetch) {
            List<String> modelList = queryFactory.select(
                            carCatalog.model
                    )
                    .from(carCatalog)
                    .where(carCatalog.make.eq(make))
                    .fetch();
            CarCatalogResponse build = CarCatalogResponse.builder()
                    .manufacturer(make)
                    .model(modelList)
                    .build();
            result.add(build);
        }

        return result;
    }
}
