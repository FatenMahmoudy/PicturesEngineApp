//
//  PhotosNetworkService.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation

public protocol PhotosNetworkService {

  /// Get weather data for a given city
  /// - Parameters:
  ///   - city: city name
  ///   - completion: result can be citie weather data or an error
  func getWeatherData(for city: String, completion: @escaping (Result<APIWeatherData, WeatherAPIError>) -> Void)
}

public class WeatherNetwork: WeatherNetworkService {

  public init() {}
  
  public func getWeatherData(
    for city: String,
    completion: @escaping (Result<APIWeatherData, WeatherAPIError>) -> Void
  ) {
    let endPoint = AppAPI.getWeatherDataByCityName(cityName: city)
    var urlComponents = URLComponents(string: endPoint.baseURL?.appendingPathComponent(endPoint.path).absoluteString ?? "")

    urlComponents?.queryItems = endPoint.queryItems

    guard let urlRequest = urlComponents?.url else {
      completion(.failure(.urlFailed))
      return }

    performNetworkTask(
      query: urlRequest,
      type: APIWeatherData.self)
    { result in
      completion(result)
    }
  }

  private func performNetworkTask<T: Decodable>(
    query: URL,
    type: T.Type,
    completion: @escaping (Result<T, WeatherAPIError>) -> Void
  ) {
    
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    
    let session = URLSession(configuration: configuration)
    
    let urlSession = session.dataTask(with: query) { (data, urlResponse, error) in
      if error != nil {
        completion(.failure(.requestError))
        return
      }
      guard let data else {
        completion(.failure(.noData))
        return
      }
      guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
        completion(.failure(.parsingFailed))
        return
      }
      completion(.success(decoded))
    }
    urlSession.resume()
  }
}
