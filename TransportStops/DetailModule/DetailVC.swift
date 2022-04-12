import UIKit
import MapKit
import CoreLocation
import FloatingPanel
import SnapKit

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
        // Constraints
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupCloseButton() {
        mapView.addSubview(closeButton)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = #colorLiteral(red: 0.2823102176, green: 0.1690107286, blue: 0.146335572, alpha: 1)
        
        closeButton.addTarget(self, action: #selector(closeMap), for: .touchUpInside)
        // Constraints
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.right.equalToSuperview().inset(20)
        }
    }
    
    @objc private func closeMap() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SecondView Protocol

extension DetailVC: DetailViewProtocol {
    
    func setOneBusStopOnMap(oneBusStop: Stop) {
        setupPlacemark(
            lat: oneBusStop.lat,
            lon: oneBusStop.lon,
            name: oneBusStop.name
        )
    }
    
    func setBottomView(with oneBusStop: Stop) {
        let bottomVC = ModuleAssembler.createFloatingModule(oneBusStop: oneBusStop)
        setupViewViaFloatingPanel(with: bottomVC)
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
        geocoder.reverseGeocodeLocation(
            CLLocation( latitude: lat, longitude: lon)) { [weak self] placemarks, error in
                if let error = error {
                print(error)
                }
        guard let placemarks = placemarks else { return }
        let placemark = placemarks.first
            
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        guard let placemarkLocation = placemark?.location else { return }
        annotation.coordinate = placemarkLocation.coordinate
        annotationsArray.append(annotation)
        self?.mapView.showAnnotations(annotationsArray, animated: false)
        }
    }
}

// MARK: - Setup Floating Panel

extension DetailVC {
    
    private func setupViewViaFloatingPanel(with contentViewController: UIViewController) {
        let floatingPanel = FloatingPanelController()
        floatingPanel.delegate = self
        floatingPanel.addPanel(toParent: self)
        floatingPanel.surfaceView.layer.cornerRadius = 20
        floatingPanel.surfaceView.clipsToBounds = true
        floatingPanel.set(contentViewController: contentViewController)
    }
}
