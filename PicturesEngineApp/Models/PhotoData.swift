//
//  PhotoData.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

struct PhotoData: Codable {
  let id: Int
  let largeImageURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case largeImageURL
  }
}
