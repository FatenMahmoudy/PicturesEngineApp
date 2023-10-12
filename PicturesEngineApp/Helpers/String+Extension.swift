//
//  String+Extension.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 11/10/2023.
//

import Foundation

extension String {
  func getImageURLfromString() -> URL? {
    return URL(string: self)
  }
}
