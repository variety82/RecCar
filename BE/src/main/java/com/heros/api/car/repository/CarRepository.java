package com.heros.api.car.repository;

import com.heros.api.car.entity.Car;
import com.heros.api.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CarRepository extends JpaRepository<Car, Long> {
    Car findByUserAndReturned(User user, Boolean returned);
}
