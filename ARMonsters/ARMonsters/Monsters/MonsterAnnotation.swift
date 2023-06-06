//
//  MonsterAnnotation.swift
//  ARMonsters
//
//  Created by Nataly on 04.06.2023.
//

import Foundation
import UIKit
import MapKit

class MonsterAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var monster: Monster?
    
    init(coordinate: CLLocationCoordinate2D, monster: Monster?) {
        self.coordinate = coordinate
        self.monster = monster
        super.init()
    }
}

