import UIKit
import MapKit
import CoreLocation

final class LocationViewController: BaseViewController {
    
    struct Contants {
        static let absoluteInsetTop: CGFloat = 66
        static let absoluteInsetBottom: CGFloat = 36
        static let padding: CGFloat = 17
        static let height: CGFloat = 90
        static let width: CGFloat = 260
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Private Variable
    

    private lazy var presenter: LocationPresenter = {
        let presenter = LocationPresenter()
        presenter.view = self
        return presenter
    }()
    private lazy var brandDetailView: BrandInformationView = {
        let brandDetailView = BrandInformationView()
        brandDetailView.backgroundColor = R.color.white100() ?? .white
        brandDetailView.translatesAutoresizingMaskIntoConstraints = false
        return brandDetailView
    }()
    
    private var locationManager = CLLocationManager()
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocaion()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
        
    // MARK: - IBAction
    
    @IBAction private func locatedButtonTapped(_ sender: Any) {
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }
}
// MARK: - Private

private extension LocationViewController {
    func setupUI() {
        addBrandInformationView()
        mapViewBrandDetailGesture()
        mapViewTapGesture()
    }
    
    func setUpMapView(latitude: Double, longitude: Double) {
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
    }
    
    func mapViewTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapHiddenView(_:)))
        mapView.addGestureRecognizer(tap)
    }
    
    @objc func handleTapHiddenView(_ sender: UITapGestureRecognizer? = nil) {
        brandDetailView.isHidden = true
    }
    
    func addBrandInformationView() {
        view.insertSubview(brandDetailView, aboveSubview: mapView)
        brandDetailView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -(LocationViewController.Contants.padding)).isActive = true
        brandDetailView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -(LocationViewController.Contants.absoluteInsetBottom + LocationViewController.Contants.padding)).isActive = true
        brandDetailView.widthAnchor.constraint(equalToConstant: LocationViewController.Contants.width).isActive = true
        brandDetailView.heightAnchor.constraint(equalToConstant: LocationViewController.Contants.height).isActive = true
        brandDetailView.layoutIfNeeded()
    }
    
    func mapViewBrandDetailGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapDetailBrandView(_:)))
        brandDetailView.addGestureRecognizer(tap)
    }
    
    @objc func handleTapDetailBrandView(_ sender: UITapGestureRecognizer? = nil) {
        if let topVC = UIViewController.topViewController(), let brand = brandDetailView.brand {
            let vc = DetailBrandViewController.makeMe()
            vc.brandId = brand.id
            topVC.pushViewController(vc, animated: true)
        }
    }
    
    func getCurrentLocaion() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
}
    
// MARK: - MKMapViewDelegate

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let brandMarker = annotation as? BrandMarker else { return nil }
        let annotationView = BrandAnnotationView()
        annotationView.annotation = brandMarker
        annotationView.image = R.image.locationPin()
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let brandMarker = view.annotation as? BrandMarker else { return }
        brandDetailView.brand = brandMarker.brand
        brandDetailView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        brandDetailView.isHidden = true
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: ", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            presenter.onGetDataLocation(latitude, longitude)
            setUpMapView(latitude: latitude, longitude: longitude)
            locationManager.stopUpdatingLocation()
        }
    }
}

// MARK: - LocationViewInput

extension LocationViewController: LocationViewInput {
    func updatePinOnMap(with brands: [BrandModel]) {
        var annotations: [BrandMarker] = []
        for item in brands {
            let coordinate = CLLocationCoordinate2D(latitude: item.x, longitude: item.y)
            let pin = BrandMarker(brand: item, coordinate: coordinate)
            annotations.append(pin)
        }
        mapView.addAnnotations(annotations)
        brandDetailView.isHidden = brands.isEmpty
        brandDetailView.brand = brands[safe: 0]
    }
}
