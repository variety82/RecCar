package com.heros.api.car.service;

import com.heros.api.car.dto.request.CarCreate;
import com.heros.api.car.dto.request.CarModify;
import com.heros.api.car.dto.response.CarCatalogResponse;
import com.heros.api.car.dto.response.CarListResponse;
import com.heros.api.car.dto.response.CarResponse;
import com.heros.api.car.entity.Car;
import com.heros.api.car.entity.CarCatalog;
import com.heros.api.car.repository.CarRepository;
import com.heros.api.detectionInfo.repository.DetectionInfoRepository;
import com.heros.api.user.entity.User;
import com.heros.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    private final DetectionInfoRepository detectionInfoRepository;

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
        user.setCurrentCarVideo(0);
        userRepository.save(user);
        return carId;
    }

    public CarResponse modifyCar(CarModify carModify) {
        Car car = carRepository.findById(carModify.getCarId()).get();
        car.ModifyCar(carModify);
        return new CarResponse(carRepository.save(car));
    }

    public List<CarListResponse> findCarList(User user) {
        List<Car> carList = userRepository.findById(user.getUserId()).get().getCars();
        List<CarListResponse> carResponseList = new ArrayList<>();
        for (Car car: carList) {
            carResponseList.add(new CarListResponse(car));
        }
        return carResponseList;
    }

    public CarResponse findCar(User user) {
//        Car car = carRepository.findByUserAndReturned(userRepository.findById(userId).get(), false);
        Car car = carRepository.findById(user.getCurrentCarId()).get();
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
    @Transactional
    public void deleteCar(Long carId, User user) {
        Car car = carRepository.findById(carId).get();
        detectionInfoRepository.deleteAllByCar(car);
        carRepository.delete(car);
        if (user.getCurrentCarId().equals(carId)) {
            user.setCurrentCarId(0L);
            user.setCurrentCarVideo(0);
            userRepository.save(user);
        }
    }

    public CarResponse returnCar(User user) {
        if (user.getCurrentCarId() == 0)
            return null;
        Car car = carRepository.findById(user.getCurrentCarId()).get();
        if (car == null)
            return null;
        car.ReturnCar();
        carRepository.save(car);
        user.setCurrentCarId(0L);
        user.setCurrentCarVideo(0);
        userRepository.save(user);
        return new CarResponse(car);
    }
}
