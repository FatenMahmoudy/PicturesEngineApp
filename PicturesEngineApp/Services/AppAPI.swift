//
//  AppAPI.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

public enum AppAPI {
  case getPhotos(searchQuery: String)
}

extension AppAPI: EndpointType {
  
  var apiKey: String {
    return "18021445-326cf5bcd3658777a9d22df6f"
  }
  
  var baseURL: URL? {
    return URL.init(string: "https://pixabay.com/api")
  }
  //"https://pixabay.com/api/?key={ KEY }&q=yellow+flowers&image_type=photo"
  
  var path: String {
    switch self {
    case .getPhotos:
      return "weather"
    }
  }
  
  var queryItems: [URLQueryItem] {
    switch self {
    case let .getPhotos(searchQuery):
      return [
        URLQueryItem(name: "q", value: searchQuery + "&image_type=photo"),
        URLQueryItem(name: "key", value: apiKey)
      ]
    }
  }
}
