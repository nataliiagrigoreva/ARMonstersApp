//  ARMonsters
//
//  Created by Nataly on 03.06.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background1")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Пользователь еще не принял решение
            showLocationRequestScreen()
        case .restricted, .denied:
            // Пользователь запретил доступ к геолокации
            showNoLocationPermissionScreen()
        case .authorizedAlways, .authorizedWhenInUse:
            // Доступ к геолокации разрешен
            showMapScreen()
        @unknown default:
            break
        }
    }
    
    // MARK: - Screens
    
    func showLocationRequestScreen() {
        let locationRequestVC = LocationRequestViewController()
        navigationController?.pushViewController(locationRequestVC, animated: true)
    }
    
    func showNoLocationPermissionScreen() {
        let noPermissionVC = NoLocationPermissionViewController()
        navigationController?.pushViewController(noPermissionVC, animated: true)
    }
    
    func showMapScreen() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
