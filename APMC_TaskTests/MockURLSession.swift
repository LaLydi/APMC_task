//
//  MockURLSession.swift
//  APMC_TaskTests
//
//  Created by Lydia on 2025-02-03.
//

import Foundation
@testable import APMC_Task

class MockURLSession: NetworkControllerDelegate {
    
    var data: Data?
    var error: Error?
    var statusCode: Int = 200
    
    init(data: Data?, error: Error? = nil, statusCode: Int = 200) {
        self.data = data
        self.error = error
        self.statusCode = statusCode
    }
    
    func fetch(resourceType: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            if statusCode >= 200 && statusCode < 300 {
                completion(.success(data))
            } else {
                completion(.failure(NetworkManager.NetworkError.serverError))
            }
        } else {
            completion(.failure(NetworkManager.NetworkError.invalidData))
        }
    }
}

