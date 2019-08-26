//
//  SendGeoPresenter.swift
//  Driver
//
//  Created by Татьяна Хохлова on 25/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit
import CoreLocation

final class SendGeoPresenter: NSObject {

    weak var viewInput: SendGeoViewInput?
    let interactor: SendGeoInteractorProtocol
    let router: SendGeoRouterInput

    let locationManager = CLLocationManager()

    var coordinate: CLLocationCoordinate2D?

    required init(viewInput: SendGeoViewInput,
                  interactor: SendGeoInteractorProtocol,
                  router: SendGeoRouterInput) {
        self.viewInput = viewInput
        self.interactor = interactor
        self.router = router
    }

}

// MARK: - SendGeoViewOutput

extension SendGeoPresenter: SendGeoViewOutput {

    func moduleWasLoaded() {
        let status = CLLocationManager.authorizationStatus()
        if (status == CLAuthorizationStatus.denied) {
            router.openGeoAccessAlert()
        } else {
            locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        }
    }

    func sendGeo() {
        guard let coordinate = coordinate else {
            viewInput?.stopLoad()
            router.showAlert(message: "Не удалось отправить геопозицию")
            return
        }
        interactor.sendGeo(latitude: coordinate.latitude,
                           longitude: coordinate.longitude) { (result) in
                            DispatchQueue.main.async { [weak self] in
                                self?.viewInput?.stopLoad()
                                switch result {
                                case .success:
                                    self?.router.showAlert(message: "Успешно отправлено")
                                case .failure(.error(message: let message)):
                                    self?.router.showAlert(message: message ?? "Не удалось отправить геопозицию")
                                }
                            }
        }
    }

    func exit() {
        interactor.exit()
        router.showMain()
    }
    
}

// MARK: - CLLocationManagerDelegate

extension SendGeoPresenter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in

            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self?.coordinate = locValue
            self?.viewInput?.updateGeo(latitude: locValue.latitude, longitude: locValue.longitude)
        }
    }

}

