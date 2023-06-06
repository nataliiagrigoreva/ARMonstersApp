//
//  MonsterCell.swift
//  ARMonsters
//
//  Created by Nataly on 05.06.2023.
//

import Foundation
import UIKit
import CoreLocation

class MonsterCell: UITableViewCell {
    var monsterImageView: UIImageView!
    var nameLabel: UILabel!
    var levelLabel: UILabel!
    var monster: Monster!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
 
        monsterImageView = UIImageView()
        monsterImageView.contentMode = .scaleAspectFit
        monsterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(monsterImageView)
        
        NSLayoutConstraint.activate([
            monsterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            monsterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            monsterImageView.widthAnchor.constraint(equalToConstant: 60),
            monsterImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: monsterImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        levelLabel = UILabel()
        levelLabel.textColor = .white
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(levelLabel)
        
        NSLayoutConstraint.activate([
            levelLabel.leadingAnchor.constraint(equalTo: monsterImageView.trailingAnchor, constant: 16),
            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with monster: Monster) {
        self.monster = monster
        monsterImageView.image = monster.image
        nameLabel.text = monster.name
        levelLabel.text = "Уровень: \(monster.level)"
    }
}
