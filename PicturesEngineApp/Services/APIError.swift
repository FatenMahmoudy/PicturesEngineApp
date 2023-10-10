//
//  Error.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

enum APIError: Error {
    case technical
    case noData
    case requestError
    case parsingFailed
}
