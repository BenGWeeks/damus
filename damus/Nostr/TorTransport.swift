//
//  TorTransport.swift
//  damus
//
//  Created by Ben Weeks on 24/04/2023.
//

import Foundation
import Tor

class TorTransport: NSObject, URLSessionDelegate, Transport {
    private var session: URLSession?
    private let torClient: TorClient

    init(torClient: TorClient = .shared) {
        self.torClient = torClient
        super.init()
        configureSession()
    }

    func configureSession() {
        let config = URLSessionConfiguration.ephemeral
        config.connectionProxyDictionary = torClient.proxyDictionary
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    func connect(urlRequest: URLRequest, completion: @escaping (Result<TransportConnectResult, Error>) -> Void) {
        guard let url = urlRequest.url else {
            completion(.failure(TransportError.invalidUrl))
            return
        }
        
        var request = urlRequest
        request.timeoutInterval = 30
        
        let task = session?.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(TransportError.invalidResponse))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completion(.failure(TransportError.invalidStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(TransportError.noData))
                return
            }
            
            let result = TransportConnectResult(data: data, response: response)
            completion(.success(result))
        }
        
        task?.resume()
    }

    func write(data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.failure(TransportError.writeNotSupported))
    }

    func stop() {
        session?.invalidateAndCancel()
        session = nil
    }
}
