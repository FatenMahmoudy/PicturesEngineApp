//
//  SearchViewModel.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

final class SearchViewModel {
  
  private let perPage: Int = 15
  private let networkService: PhotosNetworkService
  private var currentPage: Int = 1
  private var currentSearchQuery: CurrentSearch?
  private(set) var selectedPhotos: [PhotoData] = []
  
  @Published private(set) var photosVM : [SearchCollectionCellViewModel] = []
  @Published private(set) var isValidateButtonEnabled: Bool = false
  
  init(networkService: PhotosNetworkService) {
    self.networkService = networkService
  }
  
  func getPhotosSearch(query: String) async throws {
    
    do {
      let result = try await networkService.getPhotos(from: query, page: currentPage, perPage: perPage)
      guard let photos = result.photos else { throw APIError.noData }
      currentSearchQuery = CurrentSearch(query: query, total: result.total)
      let photosVM = photos.compactMap({
        SearchCollectionCellViewModel(photo: $0)
      })
      
      self.photosVM.append(contentsOf: photosVM)
      
    } catch {
      throw APIError.technical
    }
  }
  
  func getNextPhotosSearch() async throws {
    guard let currentSearchQuery, currentPage < currentSearchQuery.total / perPage else { return }
    currentPage += 1
    try await getPhotosSearch(query: currentSearchQuery.query)
  }
  
  func removeLastSearchList() {
    currentSearchQuery = nil
    photosVM.removeAll()
    selectedPhotos.removeAll()
    isValidateButtonEnabled = false
  }
  
  func updateSelectedPhotos(photo: PhotoData) {
    
    let isPhotoExist = selectedPhotos.filter {  $0.id == photo.id }.isEmpty == false
    if isPhotoExist {
      selectedPhotos.removeAll { $0.id == photo.id}
    } else {
      selectedPhotos.append(photo)
    }
    
    isValidateButtonEnabled = selectedPhotos.count >= 2
  }
}

extension SearchViewModel {
  struct CurrentSearch {
    let query: String
    let total: Int
  }
}
