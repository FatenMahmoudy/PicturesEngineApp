//
//  SearchResponse.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

struct SearchResponse: Codable {
  let total: Int
  let max: Int
  let photos: [PhotoData]?
  
  enum CodingKeys: String, CodingKey {
    case total
    case max = "totalHits"
    case photos = "hits"
  }
}
