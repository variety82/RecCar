package com.heros.api.car.service;

import com.heros.api.car.dto.request.CarCreate;
import com.heros.api.car.dto.request.CarModify;
import com.heros.api.car.dto.response.CarCatalogResponse;
import com.heros.api.car.dto.response.CarResponse;
import com.heros.api.car.entity.Car;
import com.heros.api.car.entity.CarCatalog;
import com.heros.api.car.repository.CarRepository;
import com.heros.api.user.entity.User;
import com.heros.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Log4j2
@Service
@RequiredArgsConstructor
public class CarService {
    private final CarRepository carRepository;
    private final UserRepository userRepository;

    public Long createCar(CarCreate carCreate, User user) {
        Car car = Car.builder()
                .user(user)
                .carNumber(carCreate.getCarNumber())
                .carManufacturer(carCreate.getCarManufacturer())
                .carModel(carCreate.getCarModel())
                .carFuel(carCreate.getCarFuel())
                .rentalDate(carCreate.getRentalDate())
                .returnDate(carCreate.getReturnDate())
                .rentalCompany(carCreate.getRentalCompany())
                .returned(false)
                .build();
        Long carId = carRepository.save(car).getCarId();
        user.setCurrentCarId(carId);
        userRepository.save(user);
        return carId;
    }

    public void modifyCar(CarModify carModify) {
        Car car = new Car(carModify, carRepository.findById(carModify.getCarId()).get());
        carRepository.save(car);
    }

    public List<CarResponse> findCarList(Long userId) {
        List<Car> carList = userRepository.findById(userId).get().getCars();
        List<CarResponse> carResponseList = new ArrayList<>();
        for (Car car: carList) {
            carResponseList.add(new CarResponse(car));
        }
        return carResponseList;
    }

    public CarResponse findCar(Long userId) {
        Car car = carRepository.findByUserAndReturned(userRepository.findById(userId).get(), false);
        if (car == null)
            return null;
        return new CarResponse(car);
    }

    public List<CarCatalogResponse> getCatalog() {
        List<CarCatalog> catalogs = carRepository.getCatalog();

        Map<String, String> makeWithLogo = new HashMap<>();
        for (CarCatalog carCatalog : catalogs) {
            makeWithLogo.put(carCatalog.getMake(), carCatalog.getLogoURL());
        }

        List<CarCatalogResponse> result = new ArrayList<>();
        for (String make : makeWithLogo.keySet()) {
            List<String> model = new ArrayList<>();
            for (CarCatalog carCatalog : catalogs) {
                if (carCatalog.getMake().equals(make)){
                    model.add(carCatalog.getModel());
                }
            }
            result.add(CarCatalogResponse.builder()
                    .manufacturer(make)
                    .logoUrl(makeWithLogo.get(make))
                    .model(model)
                    .build());
        }

        return result;
    }
}
