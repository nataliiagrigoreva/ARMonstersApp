//import UIKit
//import MapKit
//
//class CatchMonstersViewController: UIViewController {
//    var selectedMonster: Monster?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let monster = selectedMonster {
//            // Display information about the selected monster
//            let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//            nameLabel.text = monster.name
//            nameLabel.center = view.center
//            nameLabel.textAlignment = .center
//            view.addSubview(nameLabel)
//        }
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let catchMonstersVC = segue.destination as? CatchMonstersViewController, let monster = sender as? Monster {
//            catchMonstersVC.selectedMonster = monster
//        }
//    }
//
//}
