import Foundation

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    var busStops: [BusStop] { get }
    func getAllBusStops()
}

class MainPresenter: MainPresenterProtocol {
    
    let view: MainViewProtocol
    let networkService: NetworkServiceProtocol
    
    var busStops: [BusStop] = []
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    // 2
    func getAllBusStops() {
        networkService.getAllBusStops { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResults):
                    self.busStops = searchResults.data
                    self.view.setAllBusStops()
                    
                case .failure(let error):
                    self.view.showAlert(with: error)
                }
            }
        }
    }
    
}
