//
//  MKImageView.swift
//  ARMonsters
//
//  Created by Nataly on 05.06.2023.
//

import Foundation
import UIKit
import MapKit

class MKImageView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            if let monsterAnnotation = annotation as? MonsterAnnotation {
                image = monsterAnnotation.monster?.image
            }
        }
    }
}
