//
//  MyTeamViewController.swift
//  ARMonsters
//
//  Created by Nataly on 04.06.2023.
//

import UIKit
import CoreLocation

class MyTeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var label: UILabel!
    
    init() {
        self.label = UILabel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Моя команда"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.barTintColor = UIColor.clear
        
        let backgroundImage = UIImageView(image: UIImage(named: "background2"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MonsterCell.self, forCellReuseIdentifier: "MonsterCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вы еще не поймали монстров в свою команду"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setupMonsters()
    }
    
    func setupMonsters() {
        let monsters = MyTeam.shared.getMonsters()
        if monsters.isEmpty {
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyTeam.shared.getMonsters().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonsterCell", for: indexPath) as! MonsterCell
        let monsters = MyTeam.shared.getMonsters()
        let monster = monsters[indexPath.row]
        cell.configure(with: monster)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
