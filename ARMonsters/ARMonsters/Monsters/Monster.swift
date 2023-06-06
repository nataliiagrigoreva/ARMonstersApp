//
//  Monster.swift
//  ARMonsters
//
//  Created by Nataly on 03.06.2023.
//

import UIKit
import MapKit
import CoreLocation

class Monster: NSObject, MKAnnotation {
    
    var annotation: MonsterAnnotation?
    let name: String
    let coordinate: CLLocationCoordinate2D
    let image: UIImage
    var image2: UIImage?
    var level: Int
    var imageName: String?
    
    init(name: String, coordinate: CLLocationCoordinate2D, image: UIImage, level: Int) {
        self.name = name
        self.coordinate = coordinate
        self.image = image
        self.imageName = name
        self.level = level
    }
    
    var title: String? {
        return name
    }
    
    func `catch`() -> Bool {
        let catchChance = Int.random(in: 1...100)
        return catchChance <= 20
    }
}

