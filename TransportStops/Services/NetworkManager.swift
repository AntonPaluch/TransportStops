import Foundation

protocol NetworkServiceProtocol {
    func getBusStops(completion: @escaping (Result<Data, Error>) -> Void)
    func getDetailBusStop(idOfBusStop: String, completion: @escaping (Result<Stop, Error>) -> Void)
}

class NetworkManager: NetworkServiceProtocol {
    
    private func getJSONData<T: Decodable>(
        urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
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
    
    func getBusStops(completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = URLConstant.urlAPI
        getJSONData(urlString: urlString, completion: completion)
    }
    
    func getDetailBusStop(idOfBusStop: String, completion: @escaping (Result<Stop, Error>) -> Void) {
        let urlString = "\(URLConstant.urlAPI)/\(idOfBusStop)"
        getJSONData(urlString: urlString, completion: completion)
    }
    
}
