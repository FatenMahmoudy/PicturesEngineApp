//
//  PhotoNetworkMock.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

class PhotosNetworkMock: PhotosNetworkService {
  
  init() {}
  
  func getPhotos(from query: String, page: Int) async throws -> SearchResponse {
    
    return SearchResponse(
      total: 200,
      max: 200,
      photos: [
      PhotoData(id: 1, largeImageURL: "https://pixabay.com/get/gad1cef8dd7991fd42c33edd7b006c159567619c7c3b58411697e1307bce8f632ec5be7dbe2e586c0939e0d42487ad1872b5724ab1afa5d06450eab52ff7919be_1280.jpg"),
      PhotoData(id: 2, largeImageURL: "https://pixabay.com/get/gad1cef8dd7991fd42c33edd7b006c159567619c7c3b58411697e1307bce8f632ec5be7dbe2e586c0939e0d42487ad1872b5724ab1afa5d06450eab52ff7919be_1280.jpg"),
      PhotoData(id: 3, largeImageURL: "https://pixabay.com/get/gad1cef8dd7991fd42c33edd7b006c159567619c7c3b58411697e1307bce8f632ec5be7dbe2e586c0939e0d42487ad1872b5724ab1afa5d06450eab52ff7919be_1280.jpg")
    ])
    
  }
}
