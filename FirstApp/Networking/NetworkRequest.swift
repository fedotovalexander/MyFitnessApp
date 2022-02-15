//
//  NetworkRequest.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 11.02.2022.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    func requestData(completion: @escaping(Result<Data, Error>) -> Void) {
        
        let key = "7d2ce4c660d26aaf2122fccf890f187b"
        let latitude = 55.75222
        let longitude = 37.61556
        
        let urlString = "https://api.darksky.net/forecast/\(key)/\(latitude),\(longitude)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }  
}
