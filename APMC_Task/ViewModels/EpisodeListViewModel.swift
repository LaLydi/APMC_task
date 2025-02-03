//
//  EpisodeListViewModel.swift
//  APMC_Task
//
//  Created by Lydia on 2025-02-03.
//

import Foundation

class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func fetchEpisodes() {
        isLoading = true
        
        let networkManager = NetworkManager()
        networkManager.fetchEpisodes { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            switch result {
            case .success(let episodes):
                DispatchQueue.main.async {
                    self.episodes = episodes
                }
            case .failure(let error):
                self.errorMessage = error.rawValue
            }
        }
    }
}  
