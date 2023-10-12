//
//  DetailsViewModel.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 11/10/2023.
//

import Foundation
import UIKit
import Combine

final class DetailsViewModel {
  
  private(set) var dependenciesProvider: DetailsViewProvider
  private(set) var photosToDisplay: [PhotoData]
  @Published private(set) var images: [UIImage] = []
  
  init(photos: [PhotoData], dependenciesProvider: DetailsViewProvider = DetailsViewProviderLive()) {
    photosToDisplay = photos
    self.dependenciesProvider = dependenciesProvider
  }
  
  func downloadUIImages() {
    dependenciesProvider.downloadUIImages(urls: photosToDisplay.compactMap { $0.largeImageURL }) { [weak self] imgs in
      guard let self else { return }
      self.images = imgs
    }
  }
}
