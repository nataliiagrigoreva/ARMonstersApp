//
//  LocationRequestViewController.swift
//  ARMonsters
//
//  Created by Nataly on 03.06.2023.
//

import UIKit
import CoreLocation

class LocationRequestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background1")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        requestLocationAccess()
    }
    
    private func requestLocationAccess() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationRequestViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Пользователь разрешил доступ к геолокации
            showMapScreen()
        case .denied, .restricted:
            // Пользователь запретил доступ к геолокации
            showNoLocationPermissionScreen()
        case .notDetermined:
            // Пользователь еще не принял решение
            break
        @unknown default:
            break
        }
    }
    
    func showMapScreen() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func showNoLocationPermissionScreen() {
        let noPermissionVC = NoLocationPermissionViewController()
        navigationController?.pushViewController(noPermissionVC, animated: true)
    }
}
