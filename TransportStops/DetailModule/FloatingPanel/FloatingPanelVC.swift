import UIKit
import SnapKit

protocol FloatingViewProtocol: AnyObject {
    func setupUI(oneBusStop: Stop)
}

class FloatingPanelVC: UIViewController {
    
    var presenter: FloatingPresenterProtocol!
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = #colorLiteral(red: 0.2823102176, green: 0.1690107286, blue: 0.146335572, alpha: 1)
        nameLabel.font = .app(type: .bold, size: .normal)
        return nameLabel
    }()
    
    private let typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textColor = #colorLiteral(red: 0.2823102176, green: 0.1690107286, blue: 0.146335572, alpha: 1)
        typeLabel.font = .app(type: .bold, size: .normal)
        return typeLabel
    }()
    
    private let numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.textColor = #colorLiteral(red: 0.2823102176, green: 0.1690107286, blue: 0.146335572, alpha: 1)
        numberLabel.font = .app(type: .bold, size: .normal)
        return numberLabel
    }()

    private let timeArrivalLabel: UILabel = {
        let timeArrivalLabel = UILabel()
        timeArrivalLabel.textColor = #colorLiteral(red: 0.2823102176, green: 0.1690107286, blue: 0.146335572, alpha: 1)
        timeArrivalLabel.font = .app(type: .bold, size: .normal)
        return timeArrivalLabel
    }()
    
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
        stackView.spacing = 20
        // Constraints
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(40)
        }
    }
}

// MARK: - FloatView Protocol

extension FloatingPanelVC: FloatingViewProtocol {
    
    func setupUI(oneBusStop: Stop) {
        nameLabel.text = Strings.station.rawValue + " " + oneBusStop.name
        nameLabel.numberOfLines = 0
        
        let typeString = (oneBusStop.routePath.first?.type ?? Strings.unknownState.rawValue)
        switch typeString {
        case "bus": typeLabel.text = Strings.busType.rawValue
        case "tram": typeLabel.text = Strings.tramType.rawValue
        case "train": typeLabel.text = Strings.trainType.rawValue
        default: typeLabel.text = Strings.unknownType.rawValue
        }
        
        numberLabel.text = Strings.numberRoute.rawValue + " " + (oneBusStop.routePath.first?.number ?? Strings.unknownNumber.rawValue)
        timeArrivalLabel.text = Strings.timeArrivalText.rawValue + " " + (oneBusStop.routePath.first?.timeArrival.first ?? Strings.unknownTime.rawValue)
    }
}
