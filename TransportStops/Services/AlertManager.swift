import UIKit

protocol AlertFactoryProtocol {
    static func showAlert(with error: Error) -> UIAlertController
}

class AlertFactory: AlertFactoryProtocol {
    static func showAlert(with error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "Network Error 😢",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}
