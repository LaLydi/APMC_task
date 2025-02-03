//
//  ContentView.swift
//  APMC_Task
//
//  Created by Lydia on 2025-02-03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var episodeListViewModel = EpisodeListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 8) {
                    if episodeListViewModel.isLoading {
                        ProgressView("Thanks for waiting. We are loading your favorite episodes!")
                    } else if let errorMessage = episodeListViewModel.errorMessage {
                        VStack {
                            Text("Something went wrong")
                                .font(.headline)
                                .foregroundColor(.red)
                            
                            Text(errorMessage)
                                .font(.body)
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                            
                            Button(action: {
                                episodeListViewModel.errorMessage = nil
                                episodeListViewModel.fetchEpisodes()
                            }) {
                                Text("Retry")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                    }
                    
                    ForEach(episodeListViewModel.episodes, id: \.id) { episode in
                        NavigationLink(destination: PlayerView(episode: episode)) {
                            EpisodeView(title: episode.title, duration: timeString(time: TimeInterval(episode.duration)))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Episodes")
        }
        .onAppear {
            episodeListViewModel.fetchEpisodes()
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i", minute, second)
    }
}
