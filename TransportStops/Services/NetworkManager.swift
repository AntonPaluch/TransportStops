import Foundation

protocol NetworkServiceProtocol {
    func getAllBusStops(completion: @escaping (Result<Data, Error>) -> Void)
    func getOneBusStop(idOfBusStop: String, completion: @escaping (Result<Stop, Error>) -> Void)
}

class NetworkManager: NetworkServiceProtocol {
    
    private func getJSONData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let fetchedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getAllBusStops(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop"
        getJSONData(urlString: urlString, completion: completion)
    }
    
    func getOneBusStop(idOfBusStop: String, completion: @escaping (Result<Stop, Error>) -> Void) {
        let urlString = "https://api.mosgorpass.ru/v8.2/stop/\(idOfBusStop)"
        getJSONData(urlString: urlString, completion: completion)
    }
    
}
