import Foundation

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    var busStops: [BusStop] { get }
    func getAllBusStops()
}

final class MainPresenter: MainPresenterProtocol {
    
    var busStops: [BusStop] = []
    
    weak var view: MainViewProtocol?
    
    private let networkService: NetworkServiceProtocol
        
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getAllBusStops() {
        networkService.getBusStops { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let searchResults):
                    self.busStops = searchResults.data
                    self.view?.setAllBusStops()
                    
                case .failure(let error):
                    self.view?.showAlert(with: error)
                }
            }
        }
    }
    
}
