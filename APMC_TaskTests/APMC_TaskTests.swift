//
//  APMC_TaskTests.swift
//  APMC_TaskTests
//
//  Created by Lydia on 2025-02-03.
//

import XCTest
@testable import APMC_Task

final class APMC_TaskTests: XCTestCase {

    var viewModel: EpisodeListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = EpisodeListViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchEpisodesSuccess() {
        // Prepare mock data
        let episode = Episode(id: "1", title: "Test", videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", duration: 123)
        let encoder = JSONEncoder()
        
        do {
            let mockData = try encoder.encode([episode])
            
            let mockSession = MockURLSession(data: mockData)
            let networkManager = NetworkManager(session: mockSession)
            
            let expectation = self.expectation(description: "Episodes should be fetched successfully")
            
            networkManager.fetchEpisodes { result in
                switch result {
                case .success(let episodes):
                    XCTAssertEqual(episodes.count, 1)
                    XCTAssertEqual(episodes.first?.title, "Test")
                case .failure(let error):
                    XCTFail("Expected success, but got error: \(error)")
                }
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 2, handler: nil)
        } catch {
            XCTFail("Error encoding mock data: \(error)")
        }
    }

    func testFetchEpisodesFailure() {
        let mockSession = MockURLSession(data: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        let networkManager = NetworkManager(session: mockSession)
        
        let expectation = self.expectation(description: "Fetching episodes should fail")
        
        networkManager.fetchEpisodes { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.rawValue, NetworkManager.NetworkError.unableToCompleteRequest.rawValue)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

}


