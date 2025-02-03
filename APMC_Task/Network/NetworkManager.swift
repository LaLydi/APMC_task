//
//  NetworkManager.swift
//  APMC_Task
//
//  Created by Lydia on 2025-02-03.
//

import Foundation

protocol NetworkControllerDelegate {
    func fetch(resourceType: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager {
    private var session: NetworkControllerDelegate
    private let baseURL = "https://run.mocky.io/v3/"

    // Initialize with a custom session or default to URLSession
    init(session: NetworkControllerDelegate = URLSession.shared) {
        self.session = session
    }
    
    enum NetworkError: String, Error {
        case invalidURL = "Invalid URL"
        case unableToCompleteRequest = "Unable to complete request. Please check your internet connection."
        case invalidResponse = "Invalid response from server."
        case invalidData = "The data returned by the server is invalid."
        case decodingFailed = "Could not decode the data received from the server."
        case networkError = "Network error occurred."
        case serverError = "Server returned an error."
    }

    // Fetch episodes from the server
    func fetchEpisodes(completion: @escaping (Result<[Episode], NetworkError>) -> Void) {
        let endPoint = baseURL + "8419df8e-0160-4a35-a1e6-0237a527c566"
        
        session.fetch(resourceType: endPoint) { result in
            switch result {
            case .failure(let error):
                completion(.failure(.unableToCompleteRequest))
            case .success(let data):
                do {
                    let episodes = try JSONDecoder().decode([Episode].self, from: data)
                    completion(.success(episodes))
                } catch {
                    completion(.failure(.decodingFailed))
                }
            }
        }
    }
}

// Extend URLSession to conform to the NetworkControllerDelegate
extension URLSession: NetworkControllerDelegate {
    
    func fetch(resourceType: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: resourceType) else {
            completion(.failure(NetworkManager.NetworkError.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        
        let newTask = self.dataTask(with: request) { (possibleData, possibleResponse, possibleError) in
            if let error = possibleError {
                completion(.failure(NetworkManager.NetworkError.networkError)) // General network error
                return
            }
            
            guard let response = possibleResponse as? HTTPURLResponse else {
                completion(.failure(NetworkManager.NetworkError.invalidResponse)) // Received an invalid response
                return
            }
            
            // Check if the status code is in the successful range
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkManager.NetworkError.serverError)) // Handle server errors
                return
            }
            
            guard let receivedData = possibleData else {
                completion(.failure(NetworkManager.NetworkError.invalidData))
                return
            }
            
            completion(.success(receivedData)) // Return the data on success
        }
        newTask.resume()
    }
}
