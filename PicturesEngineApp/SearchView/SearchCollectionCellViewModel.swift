//
//  SearchCollectionCellViewModel.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

final class SearchCollectionCellViewModel {
  
  private(set) var photo: PhotoData
  @Published private(set) var isSelected: Bool = false
  
  var imageURL: URL? {
    return URL(string: self.photo.largeImageURL ?? "")
  }
  
  init(photo: PhotoData) {
    self.photo = photo
  }
  
  func didTapOnCell() {
    self.isSelected.toggle()
  }
}

extension SearchCollectionCellViewModel: Equatable, Hashable {
  static func == (lhs: SearchCollectionCellViewModel, rhs: SearchCollectionCellViewModel) -> Bool {
    return lhs.photo.id == rhs.photo.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.photo.id)
  }
}
