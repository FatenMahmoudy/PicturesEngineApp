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
  private var currentSearchQuery: String?
  private(set) var selectedPhotos: [PhotoData] = []
  
  @Published private(set) var photosVM : [SearchCollectionCellViewModel] = []
  @Published private(set) var isValidateButtonEnabled: Bool = false
  
  init(networkService: PhotosNetworkService) {
    self.networkService = networkService
  }
  
  func getPhotosSearch(query: String) async throws {
    currentSearchQuery = query
    do {
      let result = try await networkService.getPhotos(from: query, page: page)
      guard let photos = result.photos else { throw APIError.noData }
      
      let photosVM = photos.compactMap({
        SearchCollectionCellViewModel(photo: $0)
      })
      
      self.photosVM.append(contentsOf: photosVM)
      
    } catch {
      throw APIError.technical
    }
  }
  
  func getNextPhotosSearch() async throws {
    guard let currentSearchQuery else { return }
    self.page += 1
    try await getPhotosSearch(query: currentSearchQuery)
  }
  
  func removeLastSearchList() {
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
