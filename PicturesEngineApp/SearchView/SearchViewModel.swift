//
//  SearchViewModel.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

final class SearchViewModel {
  
  private let networkService: PhotosNetworkService
  private var page: Int = 1
  
  
  init(networkService: PhotosNetworkService) {
    self.networkService = networkService
  }
  
  func getPhotosSearch(query: String) async throws -> [PhotoData] {
    do {
      let result = try await networkService.getPhotos(from: query, page: page)
      guard let photos = result.photos else { return [] }
      return photos
    } catch {
      throw APIError.noData
    }
  }
}
