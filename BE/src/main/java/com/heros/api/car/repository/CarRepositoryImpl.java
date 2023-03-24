package com.heros.api.car.repository;

import com.heros.api.car.entity.CarCatalog;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

import static com.heros.api.car.entity.QCarCatalog.carCatalog;

@Slf4j
@RequiredArgsConstructor
public class CarRepositoryImpl implements CarRepositorySupport{

    private final JPAQueryFactory queryFactory;

    @Override
    public List<CarCatalog> getCatalog() {
        List<CarCatalog> fetch = queryFactory.selectFrom(carCatalog).fetch();

        return fetch;
    }
}
