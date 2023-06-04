import UIKit
import MapKit
import CoreLocation

class Monster: NSObject, MKAnnotation {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let image: UIImage
    
    init(name: String, coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.name = name
        self.coordinate = coordinate
        self.image = image
    }
    
    var title: String? {
        return name
    }
}
