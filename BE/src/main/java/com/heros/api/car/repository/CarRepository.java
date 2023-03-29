package com.heros.api.car.repository;

import com.heros.api.car.entity.Car;
import com.heros.api.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

public interface CarRepository extends JpaRepository<Car, Long>, CarRepositorySupport {
    Car findByUserAndReturned(User user, Boolean returned);

    @Transactional
    @Modifying
    @Query("delete from Car where carId = :carId")
    void customDeleteCar (@Param("carId") Long carId);
}
