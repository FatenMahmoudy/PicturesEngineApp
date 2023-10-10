//
//  EndPointType.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

protocol EndpointType {
  var baseURL: URL? { get }
  var apiKey: String { get }
}
