struct URLConstant {
    static let urlAPI = "https://api.mosgorpass.ru/v8.2/stop"
}

struct Data: Decodable {
    let data: [BusStop]
}

struct BusStop: Decodable {
    let id: String
    let name: String
}

struct Stop: Decodable {
    let name: String
    let routePath: [RoutePath]
    let lat: Double
    let lon: Double
}

struct RoutePath: Decodable {
    let type: String
    let number: String
    let timeArrival: [String]
}






