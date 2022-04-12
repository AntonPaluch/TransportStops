//
//  StopsModel.swift
//  TransportStops
//
//  Created by Pandos on 04.03.2022.
//

import Foundation

struct URLConstant {
    static let urlAPI = "https://api.mosgorpass.ru/v8.2/stop"
}

struct Data: Decodable {
    let data: [Stops]
}

struct Stops: Decodable {
    let id: String
    let lat: Double
    let lon: Double
    let name: String
    
    var urlStop: URL? {
        URL(string: URLConstant.urlAPI + "\(id)")
    }
}

struct Stop: Decodable {
    let name: String
    let routePath: [RoutePath]
}

struct RoutePath: Decodable {
    let type: String
    let number: String
    let timeArrival: [String]
}






