//
//  NetworkManager.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 26/03/26.
//

import Foundation
import Combine

struct NetworkManager {
    func fetchAllCiclos(url: URL) -> AnyPublisher<[CicloSoftex], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CicloSoftex].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
