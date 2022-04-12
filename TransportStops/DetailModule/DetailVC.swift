import UIKit
import MapKit
import CoreLocation
import FloatingPanel

protocol DetailViewProtocol: AnyObject {
    func setOneBusStopOnMap(oneBusStop: Stop)
    func setBottomView(with oneBusStop: Stop)
    func showAlert(with error: Error)
}

final class DetailVC: UIViewController, FloatingPanelControllerDelegate {
    
    var presenter: DetailPresenterProtocol!
    
    private let mapView = MKMapView()
    private let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCloseButton()
        presenter.getOneBusStop()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCloseButton() {
        mapView.addSubview(closeButton)
        closeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.tintColor = .black
        
        closeButton.addTarget(self, action: #selector(closeMap), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalToSystemSpacingBelow: mapView.topAnchor, multiplier: 8).isActive = true
        closeButton.leftAnchor.constraint(equalToSystemSpacingAfter: mapView.leftAnchor, multiplier: 4).isActive = true
    }
    
    @objc private func closeMap() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SecondView Protocol

extension DetailVC: DetailViewProtocol {
    
    func setOneBusStopOnMap(oneBusStop: Stop) {
        setupPlacemark(lat: oneBusStop.lat,
                       lon: oneBusStop.lon,
                       name: oneBusStop.name)
    }
    
    func setBottomView(with oneBusStop: Stop) {
        let bottomVC = ModuleAssembler.createFloatingModule(oneBusStop: oneBusStop)
        setupBottomViewViaFloatingPanel(with: bottomVC)
    }
    
    func showAlert(with error: Error) {
        let alert = AlertFactory.showAlert(with: error)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup Placemark

extension DetailVC {
    
    private func setupPlacemark(lat: Double, lon: Double, name: String) {
        var annotationsArray: [MKPointAnnotation] = []
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat,
                                                   longitude: lon)) { [weak self] placemarks, error in
            if let error = error {
                print(error)
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = name
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat,
                                                           longitude: lon)
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            annotationsArray.append(annotation)
            
            self?.mapView.showAnnotations(annotationsArray, animated: false)
        }
    }
}

// MARK: - Setup Floating Panel

extension DetailVC {
    
    private func setupBottomViewViaFloatingPanel(with contentViewController: UIViewController) {
        let floatingPanel = FloatingPanelController()
        floatingPanel.delegate = self
        floatingPanel.addPanel(toParent: self)
        floatingPanel.surfaceView.layer.cornerRadius = 20
        floatingPanel.surfaceView.clipsToBounds = true
    
        floatingPanel.set(contentViewController: contentViewController)
    }
}
