//
//  MapViewController.swift
//  ARMonsters
//
//  Created by Nataly on 03.06.2023.
//

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
    var visibleMonsters: [Monster] = []
    let monsterCaptureChance = 0.2
    let monsterEscapeChance = 0.3
    let monsterUpdateInterval: TimeInterval = 300
    let visibleMonstersUpdateInterval: TimeInterval = 300
    var monsterUpdateTimer: Timer?
    var visibleMonstersUpdateTimer: Timer?
    var selectedMonster: Monster?
    let maxDistance: CLLocationDistance = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        
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
        startMonsterUpdateTimer()
        startVisibleMonstersUpdateTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func loadMonsters() {
        let monsterNames = ["Shadow", "Blaze", "Venom", "Frost", "Luna", "Storm", "Spike", "Ember", "Nova", "Fang"]
        
        for name in monsterNames {
            if let image = UIImage(named: name) {
                let randomLevel = Int.random(in: 5...20)
                let monster = Monster(name: name, coordinate: CLLocationCoordinate2D(), image: image, level: randomLevel)
                monsters.append(monster)
            }
        }
    }
    
    private func updateVisibleMonsters() {
        guard let userLocation = locationManager?.location?.coordinate else {
            return
        }
        
        visibleMonsters = monsters.filter { monster in
            let monsterLocation = CLLocation(latitude: monster.coordinate.latitude, longitude: monster.coordinate.longitude)
            let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            return monsterLocation.distance(from: userLocation) <= 1000
        }
        mapView?.removeAnnotations(mapView?.annotations ?? [])
        
        for monster in visibleMonsters {
            let annotation = MonsterAnnotation(coordinate: monster.coordinate, monster: monster)
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "monsterAnnotation")
            annotationView.image = monster.image
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMonsterTapped(_:)))
            annotationView.addGestureRecognizer(tapGestureRecognizer)
            monster.image2 = UIImage(named: "\(monster.name)2")
            mapView?.addAnnotation(annotation)
            monster.annotation = annotation
        }
    }
    
    func startMonsterUpdateTimer() {
        monsterUpdateTimer = Timer.scheduledTimer(withTimeInterval: monsterUpdateInterval, repeats: true) { [weak self] _ in
            self?.updateMonsterList()
        }
        monsterUpdateTimer?.fire()
    }
    
    private func updateMonsterList() {
        monsters = monsters.filter { _ in
            return Double.random(in: 0...1) > monsterCaptureChance
        }
        
        for _ in 1...30 {
            if let userLocation = locationManager?.location?.coordinate {
                let randomCoordinate = generateRandomCoordinate(from: userLocation, radius: 1000)
                let randomName = generateRandomMonsterName()
                if let image = UIImage(named: randomName) {
                    let level = 0
                    let monster = Monster(name: randomName, coordinate: randomCoordinate, image: image, level: level)
                    monsters.append(monster)
                }
            }
        }
        updateVisibleMonsters()
    }
    
    private func startVisibleMonstersUpdateTimer() {
        visibleMonstersUpdateTimer?.invalidate()
        visibleMonstersUpdateTimer = Timer.scheduledTimer(withTimeInterval: visibleMonstersUpdateInterval, repeats: true) { [weak self] _ in
            self?.updateVisibleMonsters()
        }
        visibleMonstersUpdateTimer?.fire()
    }
    
    private func generateRandomMonsterName() -> String {
        let monsterNames = ["Shadow", "Blaze", "Venom", "Frost", "Luna", "Storm", "Spike", "Ember", "Nova", "Fang"]
        let randomIndex = Int.random(in: 0..<monsterNames.count)
        return monsterNames[randomIndex]
    }
    
    private func generateRandomCoordinate(from center: CLLocationCoordinate2D, radius: Double) -> CLLocationCoordinate2D {
        let randomAngle = Double.random(in: 0...(2 * Double.pi))
        let randomDistance = Double.random(in: 0...radius)
        let deltaLatitude = randomDistance * cos(randomAngle) / 111111.0
        let deltaLongitude = randomDistance * sin(randomAngle) / (111111.0 * cos(center.latitude * Double.pi / 180.0))
        let newLatitude = center.latitude + deltaLatitude
        let newLongitude = center.longitude + deltaLongitude
        
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
    
    @objc func zoomInButtonTapped() {
        var region = mapView?.region
        region?.span.latitudeDelta /= 2
        region?.span.longitudeDelta /= 2
        mapView?.setRegion(region!, animated: true)
    }
    
    @objc func zoomOutButtonTapped() {
        var region = mapView?.region
        region?.span.latitudeDelta *= 2
        region?.span.longitudeDelta *= 2
        mapView?.setRegion(region!, animated: true)
    }
    
    @objc func moveToMyLocationButtonTapped() {
        if let userLocation = mapView?.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView?.setRegion(region, animated: true)
        }
    }
    
    @objc func teamButtonTapped() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(MyTeamViewController(), animated: true)
    }
    
    @objc func handleMonsterTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let annotationView = gestureRecognizer.view as? MKAnnotationView,
              let annotation = annotationView.annotation as? MonsterAnnotation else {
                  return
              }
        guard let monster = annotation.monster else {
            return
        }
        
        let userLocation = mapView?.userLocation.coordinate ?? CLLocationCoordinate2D()
        let monsterLocation = monster.coordinate
        let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            .distance(from: CLLocation(latitude: monsterLocation.latitude, longitude: monsterLocation.longitude))
        
        if distance <= maxDistance {
            if let index = monsters.firstIndex(of: monster) {
                monsters.remove(at: index)
                mapView?.removeAnnotation(annotation)
                
                let catchMonstersViewController = CatchMonstersViewController(monster: monster)
                navigationController?.pushViewController(catchMonstersViewController, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Вы находитесь слишком далеко от монстра",
                                          message: "Расстояние до монстра: \(Int(distance)) метров",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let reuseIdentifier = "userLocationAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = false
                annotationView?.image = UIImage(named: "vector")
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        } else if
            let monsterAnnotation = annotation as? MonsterAnnotation {
            let reuseIdentifier = "monsterAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = monsterAnnotation.monster?.image
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let monsterAnnotation = view.annotation as? MonsterAnnotation else {
            return
        }
        guard let monster = monsterAnnotation.monster else {
            return
        }
        selectedMonster = monster
        let userLocation = mapView.userLocation.coordinate
        let monsterLocation = monster.coordinate
        let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            .distance(from: CLLocation(latitude: monsterLocation.latitude, longitude: monsterLocation.longitude))
        if distance <= maxDistance {
            if let index = monsters.firstIndex(of: monster) {
                monsters.remove(at: index)
                mapView.removeAnnotation(monsterAnnotation)
                let catchMonstersViewController = CatchMonstersViewController(monster: monster)
                navigationController?.pushViewController(catchMonstersViewController, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Вы находитесь слишком далеко от монстра",
                                          message: "Расстояние до монстра: \(Int(distance)) метров",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {
            return
        }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView?.setRegion(region, animated: true)
        updateVisibleMonsters()
    }
}
