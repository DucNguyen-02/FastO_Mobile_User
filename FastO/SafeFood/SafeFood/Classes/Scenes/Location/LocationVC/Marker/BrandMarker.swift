import Foundation
import MapKit

final class BrandMarker: NSObject, MKAnnotation {
    var brand: BrandModel
    var coordinate: CLLocationCoordinate2D
    
    init(brand: BrandModel, coordinate: CLLocationCoordinate2D) {
        self.brand = brand
        self.coordinate = coordinate
    }
}
