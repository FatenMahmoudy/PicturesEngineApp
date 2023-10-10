//
//  PhotosNetworkService.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

protocol PhotosNetworkService {
  func getPhotos(from query: String, page: Int) async throws -> SearchResponse
}
