//
//  NetworkManager.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 26/03/26.
//

import Foundation
import Combine

final class NetworkManager {
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchAllCiclos(url: URL) -> AnyPublisher<[CicloSoftex], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CicloSoftex].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func postNewCiclo(url: URL, newCiclo: CicloSoftex){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(newCiclo)
        } catch {
            print(error)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CicloSoftex.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error creating post: \(error.localizedDescription)")
                }
            }, receiveValue: { cicloResponse in
                print("Successfully created ciclo with Periodo: \(cicloResponse.periodo)")
            })
            .store(in: &cancellables)
    }
}
