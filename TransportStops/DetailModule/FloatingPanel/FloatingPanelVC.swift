import UIKit

protocol FloatingViewProtocol: AnyObject {
    func setUIElements(oneBusStop: Stop)
}

class FloatingPanelVC: UIViewController {
    
    var presenter: FloatingPresenterProtocol!
    
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let numberLabel = UILabel()
    private let timeArrivalLabel = UILabel()
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            nameLabel,
            typeLabel,
            numberLabel,
            timeArrivalLabel
        ]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        presenter.setUIElements()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 4),
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2)
        ])
    }
    
}

// MARK: - BottomView Protocol

extension FloatingPanelVC: FloatingViewProtocol {
    
    func setUIElements(oneBusStop: Stop) {
        nameLabel.text = "🚏 Станция:" + " " + oneBusStop.name
        nameLabel.numberOfLines = 0
        
        let typeString = (oneBusStop.routePath.first?.type ?? "неизвестен 😞")
        switch typeString {
        case "bus": typeLabel.text = "Тип маршрута: Автобус 🚌"
        case "tram": typeLabel.text = "Тип маршрута: Трамвай 🚋"
        case "train": typeLabel.text = "Тип маршрута: Поезд 🚉"
        default: typeLabel.text = "Тип маршрута: Неизвестен 😞"
        }
        
        numberLabel.text = "🆔 Номер маршрута:" + " " + (oneBusStop.routePath.first?.number ?? "Неизвестен 😔")
        timeArrivalLabel.text = "🕓 Время до прибытия:" + " " + (oneBusStop.routePath.first?.timeArrival.first ?? "Неизвестно 😩")
    }
}
