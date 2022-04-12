import Foundation

protocol DetailPresenterProtocol {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, busStop: BusStop)
    var busStop: BusStop? { get }
    func getOneBusStop()
}

final class DetailPresenter: DetailPresenterProtocol {
    
    var busStop: BusStop?
    
    weak var view: DetailViewProtocol?
    
    private let networkService: NetworkServiceProtocol
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, busStop: BusStop) {
        self.view = view
        self.networkService = networkService
        self.busStop = busStop
    }
    
    func getOneBusStop() {
        networkService.getDetailBusStop(idOfBusStop: busStop?.id ?? "00014195-8703-4ee1-a55a-cc6421c2bd8f") { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let oneBusStop):
                    self.view?.setOneBusStopOnMap(oneBusStop: oneBusStop)
                    self.view?.setBottomView(with: oneBusStop)
                    
                case .failure(let error):
                    self.view?.showAlert(with: error)
                }
            }
        }
    }
    
}
