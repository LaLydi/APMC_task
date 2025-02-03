//
//  PlayerView.swift
//  APMC_Task
//
//  Created by Lydia on 2025-02-03.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    let episode: Episode
    
    @State private var player: AVPlayer?
    @State private var isLoading = true
    @State private var showOverlay = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let player = player {
                    VideoPlayer(player: player)
                        .onAppear {
                            player.play()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                
                if isLoading {
                    ProgressView("Loading video...")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    withAnimation {
                        showOverlay.toggle()
                    }
                    if showOverlay {
                        hideOverlayAfterDelay()
                    }
                }) {
                    Color.black.opacity(0.01)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.clear)
                .allowsHitTesting(!showOverlay)

                if showOverlay {
                    VStack {
                        VStack(spacing: 10) {
                            Text(episode.title)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)

                            if let description = episode.description, !description.isEmpty {
                                Text(description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                            }

                            Text("Duration: \(timeString(time: TimeInterval(episode.duration)))")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: geometry.size.width * 0.9)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.top, getSafeAreaTop())

                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: showOverlay)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
        .onAppear {
            preparePlayer()
        }
        .onDisappear {
            stopPlayer()
        }
        .edgesIgnoringSafeArea(.horizontal)
        .navigationBarHidden(!showOverlay)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func preparePlayer() {
        guard let url = URL(string: episode.videoUrl) else {
            isLoading = false
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemNewAccessLogEntry,
            object: playerItem,
            queue: .main
        ) { _ in
            isLoading = false
        }
        player?.play()
    }

    private func stopPlayer() {
        player?.pause()
        player = nil
    }

    private func hideOverlayAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showOverlay = false
            }
        }
    }

    private func getSafeAreaTop() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first?.safeAreaInsets.top ?? 0
        }
        return 0
    }

    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i", minute, second)
    }
}
