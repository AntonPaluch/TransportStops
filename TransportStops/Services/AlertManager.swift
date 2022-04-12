import UIKit

protocol AlertFactoryProtocol {
    static func showAlert(with error: Error) -> UIAlertController
}

class AlertFactory: AlertFactoryProtocol {
    static func showAlert(with error: Error) -> UIAlertController {
        let alertController = UIAlertController(
            title: Strings.alertMessage.rawValue,
                message: error.localizedDescription,
                preferredStyle: .alert
        )
        let action = UIAlertAction(title: Strings.ok.rawValue, style: .default, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}
