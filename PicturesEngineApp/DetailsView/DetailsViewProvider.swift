//
//  DetailsViewProvider.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 12/10/2023.
//

import Foundation
import UIKit

protocol DetailsViewProvider {
  func downloadUIImages(urls: [String], completion: @escaping ([UIImage]) -> Void)
}

class DetailsViewProviderLive: DetailsViewProvider {
  func downloadUIImages(urls: [String], completion: @escaping ([UIImage]) -> Void) {
    
    let group = DispatchGroup()
    var images: [UIImage] = []
    
    for url in urls {
      group.enter()
      
      if let finalURL = url.getImageURLfromString() {
        DispatchQueue.global().async {
          defer { group.leave() }
          if let data = try? Data(contentsOf: finalURL) {
            if let image = UIImage(data: data) {
              images.append(image)
            }
          }
        }
      }
    }

    group.notify(queue: DispatchQueue.main) {
      print("😍 All tasks done - \(images.count)")
      completion(images)
    }
  }
}
