//
//  NetworkingServiceTests.swift
//  PicturesEngineAppTests
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import XCTest
import Combine

@testable import PicturesEngineApp

final class NetworkingServiceTests: XCTestCase {
  
  var expectation: XCTestExpectation!
  var searchResponse: SearchResponse?
  
  var networking: PhotosNetworkService!
  var error: APIError?
  
  var cancellables: Set<AnyCancellable>!
  
  override func setUpWithError() throws {
    self.networking = PhotosNetworkLive()
    self.cancellables = []
  }
  
  override func tearDownWithError() throws {
    self.networking = nil
    self.cancellables = nil
    self.error = nil
  }
  
  func testGetPhotosNewtorkingService() async throws -> Void {
    
    var thrownError: Error?
    let errorHandler = { thrownError = $0 }
    let expectation = expectation(description: "get photos")
    
    Task {
      do {
        searchResponse = try await networking.getPhotos(from: "yellow flower", page: 1)
      } catch {
        errorHandler(error)
      }
      
      expectation.fulfill()
    }
    
//    await waitForExpectations(timeout: 5)
    await fulfillment(of: [expectation])
    
    if let error = thrownError {
      XCTFail(
        "Async error thrown: \(error)"
      )
    }
    
    XCTAssertNotNil(self.searchResponse)
    XCTAssertEqual(searchResponse?.photos?.count, 15)
  }
  
}

