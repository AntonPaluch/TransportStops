import UIKit

protocol ModuleAssemblerProtocol {
    static func createMainModule() -> UIViewController
    static func createDetailModule(busStop: BusStop) -> UIViewController
    static func createFloatingModule(oneBusStop: Stop) -> UIViewController
}

class ModuleAssembler: ModuleAssemblerProtocol {
    
    static func createMainModule() -> UIViewController {
        let view = MainVC()
        let networkManger = NetworkManager()
        let presenter = MainPresenter(view: view, networkService: networkManger)
        view.presenter = presenter
        return view
    }
    
    static func createDetailModule(busStop: BusStop) -> UIViewController {
        let view = DetailVC()
        let networkManger = NetworkManager()
        let presenter = DetailPresenter(view: view, networkService: networkManger, busStop: busStop)
        view.presenter = presenter
        return view
    }

    static func createFloatingModule(oneBusStop: Stop) -> UIViewController {
        let view = FloatingPanelVC()
        let presenter = FloatingPresenter(view: view, oneBusStop: oneBusStop)
        view.presenter = presenter
        return view
    }
}
