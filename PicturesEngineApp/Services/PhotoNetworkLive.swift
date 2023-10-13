//
//  PhotoNetworkLive.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

class PhotosNetworkLive: PhotosNetworkService {
  
  init() {}
  
  func getPhotos(from query: String, page: Int, perPage: Int) async throws -> SearchResponse {
    let endPoint = AppAPI.getPhotos(searchQuery: query, page: page, perPage: perPage)
    
    guard let baseURL = endPoint.baseURL else {
      throw APIError.technical
      }
    var urlComponents = URLComponents(string: baseURL.absoluteString)

    urlComponents?.queryItems = endPoint.queryItems
    
    guard let urlRequest = urlComponents?.url else {
      throw APIError.technical
      }
    
    let (data, _) = try await URLSession.shared.data(from: urlRequest)
    do {
      let result = try JSONDecoder().decode(SearchResponse.self, from: data)
      if let photos = result.photos, photos.isEmpty {
        throw APIError.noData
      } else {
        return result
      }
    } catch {
      throw APIError.parsingFailed
    }
  }
}
