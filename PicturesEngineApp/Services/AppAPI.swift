//
//  AppAPI.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

public enum AppAPI {
  case getPhotos(searchQuery: String, page: Int, perPage: Int)
}

extension AppAPI: EndpointType {
  
  var apiKey: String {
    return "18021445-326cf5bcd3658777a9d22df6f"
  }
  
  var baseURL: URL? {
    return URL.init(string: "https://pixabay.com/api/")
  }
  
  var queryItems: [URLQueryItem] {
    switch self {
    case let .getPhotos(searchQuery, page, perPage):
      return [
        URLQueryItem(name: "key", value: apiKey),
        URLQueryItem(name: "q", value: searchQuery),
        URLQueryItem(name: "image_type", value: "photo"),
        URLQueryItem(name: "page", value: String(page)),
        URLQueryItem(name: "per_page", value: String(perPage)),
      ]
    }
  }
}
