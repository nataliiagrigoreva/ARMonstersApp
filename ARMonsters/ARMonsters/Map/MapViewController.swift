
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var mapView: MKMapView?
    var locationManager: CLLocationManager?
    var zoomInButton: UIButton!
    var zoomOutButton: UIButton!
    var moveToMyLocationButton: UIButton!
    var teamButton: UIButton!
    var monsters: [Monster] = []
    let zoom = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize locationManager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        // Request authorization for location services
        locationManager?.requestWhenInUseAuthorization()
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        navigationController?.setNavigationBarHidden(true, animated: false) // Скрыть навигационную панель
        
        mapView = MKMapView(frame: view.bounds)
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        view.addSubview(mapView!)
        
        zoom.backgroundColor = UIColor(named: "Color")
        zoom.layer.cornerRadius = 5
        zoom.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoom)
        
        zoomInButton = UIButton(type: .system)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
        zoomInButton.tintColor = .white
        zoomInButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        zoomOutButton = UIButton(type: .system)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)
        zoomOutButton.tintColor = .white
        zoomOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        moveToMyLocationButton = UIButton(type: .system)
        moveToMyLocationButton.setImage(UIImage(named: "Location"), for: .normal)
        moveToMyLocationButton.setBackgroundImage(UIImage(named: "Ellipse"), for: .normal)
        view.addSubview(moveToMyLocationButton)
        moveToMyLocationButton.addTarget(self, action: #selector(moveToMyLocationButtonTapped), for: .touchUpInside)
        moveToMyLocationButton.tintColor = .white
        
        
        teamButton = UIButton(type: .system)
        teamButton.setTitle("Моя команда", for: .normal)
        teamButton.setTitleColor(.systemBlue, for: .normal)
        teamButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        teamButton.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
        teamButton.addTarget(self, action: #selector(teamButtonTapped), for: .touchUpInside)
        teamButton.tintColor = .white
        teamButton.layer.cornerRadius = 15
        view.addSubview(teamButton)
        
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        moveToMyLocationButton.translatesAutoresizingMaskIntoConstraints = false
        teamButton.translatesAutoresizingMaskIntoConstraints = false
        
        zoom.addSubview(zoomInButton)
        zoom.addSubview(zoomOutButton)
        NSLayoutConstraint.activate([
            mapView!.topAnchor.constraint(equalTo: view.topAnchor),
            mapView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            zoom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            zoom.widthAnchor.constraint(equalToConstant: 40),
            zoom.heightAnchor.constraint(equalToConstant: 80),
            zoom.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            zoomInButton.centerXAnchor.constraint(equalTo: zoom.centerXAnchor),
            zoomInButton.centerYAnchor.constraint(equalTo: zoom.centerYAnchor, constant: -20),
            zoomOutButton.centerXAnchor.constraint(equalTo: zoom.centerXAnchor),
            zoomOutButton.centerYAnchor.constraint(equalTo: zoom.centerYAnchor, constant: 20),
            
            moveToMyLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            moveToMyLocationButton.widthAnchor.constraint(equalToConstant: 40),
            moveToMyLocationButton.heightAnchor.constraint(equalToConstant: 40),
            moveToMyLocationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
            teamButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            teamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            teamButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            teamButton.heightAnchor.constraint(equalToConstant: 55),
            
            zoomInButton.leadingAnchor.constraint(equalTo: mapView!.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            zoomOutButton.leadingAnchor.constraint(equalTo: mapView!.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
        ])
        
        loadMonsters()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func loadMonsters() {
        let monsterNames = ["Shadow", "Blaze", "Venom", "Frost", "Luna", "Storm", "Spike", "Ember", "Nova", "Fang"]
        
        for name in monsterNames {
            if let image = UIImage(named: name) {
                let monster = Monster(name: name, coordinate: CLLocationCoordinate2D(), image: image)
                monsters.append(monster)
            }
        }
    }
    
    //    private func updateVisibleMonsters() {
    //        guard let userLocation = locationManager.location?.coordinate else {
    //            return
    //        }
    //
    //        let visibleMonsters = monsters.filter { monster in
    //            let monsterLocation = CLLocation(latitude: monster.coordinate.latitude, longitude: monster.coordinate.longitude)
    //            let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
    //            return monsterLocation.distance(from: userLocation) <= 300
    //        }
    //
    //        mapView.removeAnnotations(mapView.annotations)
    //        mapView.addAnnotations(visibleMonsters)
    //    }
    
    //    private func startMonsterUpdateTimer() {
    //        let timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
    //            self?.updateMonsterList()
    //            self?.updateVisibleMonsters()
    //        }
    //        timer.fire()
    //    }
    
    //    private func updateMonsterList() {
    //        monsters.removeAll { _ in
    //            return Int.random(in: 0...100) < 20
    //        }
    //
    //        for _ in 1...6 {
    //            if let userLocation = locationManager.location?.coordinate {
    //                let randomCoordinate = generateRandomCoordinate(from: userLocation, radius: 1000)
    //                let randomName = generateRandomMonsterName()
    //                if let image = UIImage(named: randomName) {
    //                    let monster = Monster(name: randomName, coordinate: randomCoordinate, image: image)
    //                    monsters.append(monster)
    //                }
    //            }
    //        }
    //    }
    
    private func generateRandomMonsterName() -> String {
        let monsterNames = ["Shadow", "Blaze", "Venom", "Frost", "Luna", "Storm", "Spike", "Ember", "Nova", "Fang"]
        return monsterNames.randomElement() ?? ""
    }
    
    private func generateRandomCoordinate(from coordinate: CLLocationCoordinate2D, radius: Double) -> CLLocationCoordinate2D {
        let randomAngle = Double.random(in: 0...2 * Double.pi)
        let randomDistance = Double.random(in: 0...radius)
        let latitudeOffset = randomDistance * cos(randomAngle) / 111111
        let longitudeOffset = randomDistance * sin(randomAngle) / (111111 * cos(coordinate.latitude * Double.pi / 180))
        let newLatitude = coordinate.latitude + latitudeOffset
        let newLongitude = coordinate.longitude + longitudeOffset
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
    
    @objc func zoomInButtonTapped() {
        // Увеличьте масштаб карты
        var region = mapView?.region
        region?.span.latitudeDelta /= 2
        region?.span.longitudeDelta /= 2
        mapView?.setRegion(region!, animated: true)
    }
    
    @objc func zoomOutButtonTapped() {
        // Уменьшите масштаб карты
        var region = mapView?.region
        region?.span.latitudeDelta *= 2
        region?.span.longitudeDelta *= 2
        mapView?.setRegion(region!, animated: true)
    }
    
    @objc func moveToMyLocationButtonTapped() {
        // Переместите карту к текущему местоположению пользователя
        locationManager?.startUpdatingLocation()
    }
    
    @objc func teamButtonTapped() {
        // Обработчик нажатия кнопки "Моя команда"
        // Вставьте здесь код для отображения информации о команде или выполнения других действий, связанных с командой
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserLocationAnnotation")
            annotationView.image = UIImage(named: "vector")
            return annotationView
        }
        return nil
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // Обработчик обновления местоположения пользователя
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView?.setRegion(region, animated: true)
            locationManager?.stopUpdatingLocation()
        }
    }
}

