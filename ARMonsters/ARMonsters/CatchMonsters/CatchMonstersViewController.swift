//
//  CatchMonstersViewController.swift
//  ARMonsters
//
//  Created by Nataly on 03.06.2023.
//

import UIKit
import MapKit
import CoreLocation

class CatchMonstersViewController: UIViewController {
    let monster: Monster
    let catchButton: UIButton
    let levelLabel: UILabel
    let monsterImageView: UIImageView
    let randomLevel: Int
    
    init(monster: Monster) {
        self.monster = monster
        catchButton = UIButton(type: .system)
        levelLabel = UILabel()
        monsterImageView = UIImageView(image: monster.image2)
        randomLevel = Int.random(in: 5...20)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Room")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        setupMonsterImageView()
        setupLevelLabel()
        setupCatchButton()
    }
    
    func setupMonsterImageView() {
        monsterImageView.contentMode = .scaleAspectFit
        monsterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monsterImageView)
        
        NSLayoutConstraint.activate([
            monsterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monsterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            monsterImageView.widthAnchor.constraint(equalToConstant: 191),
            monsterImageView.heightAnchor.constraint(equalToConstant: 254)
        ])
    }
    
    func setupLevelLabel() {
        let labelText = "\(monster.name) Уровень: \(randomLevel)"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        levelLabel.attributedText = attributedText
        levelLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Rectangle")!)
        levelLabel.textColor = .white
        levelLabel.textAlignment = .center
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelLabel)
        
        NSLayoutConstraint.activate([
            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelLabel.topAnchor.constraint(equalTo: monsterImageView.bottomAnchor, constant: 16),
            levelLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            levelLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            levelLabel.widthAnchor.constraint(equalTo: levelLabel.widthAnchor)
        ])
    }
    
    func setupCatchButton() {
        catchButton.setTitle("Попробовать поймать", for: .normal)
        catchButton.addTarget(self, action: #selector(catchButtonTapped), for: .touchUpInside)
        catchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(catchButton)
        catchButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        catchButton.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
        catchButton.tintColor = .white
        catchButton.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            catchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            catchButton.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16)
        ])
    }
    
    @objc func catchButtonTapped() {
        let success = monster.catch()
        if success {
            MyTeam.shared.addMonster(monster, level: randomLevel)
            
            let alert = UIAlertController(title: "Ура! Вы поймали монстра \(monster.name) в свою команду",
                                          message: nil,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Вернуться на карту", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            
            present(alert, animated: true, completion: nil)
        } else {
            let randomChance = Int.random(in: 1...100)
            if randomChance <= 30 {
                let alert = UIAlertController(title: "Монстр убежал!",
                                              message: nil,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Вернуться на карту", style: .default, handler: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Не вышло :( Попробуйте поймать ещё раз!",
                                              message: nil,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
