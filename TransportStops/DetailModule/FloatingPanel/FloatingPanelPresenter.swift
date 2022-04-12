import Foundation

protocol FloatingPresenterProtocol {
    init(view: FloatingViewProtocol, oneBusStop: Stop)
    var oneBusStop: Stop { get }
    func setUIElements()
}

class FloatingPresenter: FloatingPresenterProtocol {
    
    let view: FloatingViewProtocol
    
    var oneBusStop: Stop
    
    required init(view: FloatingViewProtocol, oneBusStop: Stop) {
        self.view = view
        self.oneBusStop = oneBusStop
    }
    
    func setUIElements() {
        view.setupUI(oneBusStop: oneBusStop)
    }

}
