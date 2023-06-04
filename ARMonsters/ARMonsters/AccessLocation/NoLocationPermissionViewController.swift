//
//  NoLocationPermissionViewController.swift
//  ARMonsters
//
//  Created by Nataly on 03.06.2023.
//

// NoLocationPermissionViewController.swift
import UIKit

class NoLocationPermissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background1")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        showLocationPermissionAlert()
    }
    
    // Метод для отображения предупреждения о запрете доступа к геолокации
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Уведомление", message: "Мы не знаем где Вы находитесь на карте, разрешите нам определить ваше местоположение, это делается в настройках устройства.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Перейти к настройкам", style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}

