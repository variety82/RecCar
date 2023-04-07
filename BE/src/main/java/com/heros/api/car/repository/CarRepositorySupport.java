package com.heros.api.car.repository;

import com.heros.api.car.entity.CarCatalog;

import java.util.List;

public interface CarRepositorySupport {
    List<CarCatalog> getCatalog();
}
