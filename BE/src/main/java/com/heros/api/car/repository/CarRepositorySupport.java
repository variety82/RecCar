package com.heros.api.car.repository;

import com.heros.api.car.dto.response.CarCatalogResponse;

import java.util.List;

public interface CarRepositorySupport {
    List<CarCatalogResponse> getCatalog();
}
