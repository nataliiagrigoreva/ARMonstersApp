//
//  MyTeam.swift
//  ARMonsters
//
//  Created by Nataly on 05.06.2023.
//

import Foundation
import UIKit
import MapKit

class MyTeam {
    static let shared = MyTeam()
    private var monsters: [Monster] = []
    
    private init() {}
    
    func addMonster(_ monster: Monster, level: Int) {
        monster.level = level
        monsters.append(monster)
    }
    
    func getMonsters() -> [Monster] {
        return monsters
    }
}
