//
//  RMService.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import Foundation

/// Pirmary API service object to get Rick and Morty data
final class RMService {
  /// Singleton instance of the class
  static let shared = RMService()
  
  /// RMAPICacheManager static object
  private let cacheManager = RMAPICacheManager()
  
  enum RMServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
  }
  
  private init() {}
  
  private func request(from rmRequest: RMRequest) -> URLRequest? {
    guard let url = rmRequest.url else {
      return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = rmRequest.httpMethod
    return request
  }
  
  /// Send Rick and Morty API call
  /// - Parameters:
  ///   - request: request instance
  ///   - type: type of the object we aspect to get back
  ///   - completion: callback data or error
  public func execute<T: Codable>(
    _ request: RMRequest,
    expecting type: T.Type,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
      do {
        let result = try JSONDecoder().decode(type.self, from: cachedData)
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
      return
    }
    guard let urlRequest = self.request(from: request) else {
      completion(.failure(RMServiceError.failedToCreateRequest))
      return
    }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? RMServiceError.failedToGetData))
        return
      }
      
      do {
        let result = try JSONDecoder().decode(type.self, from: data)
        self?.cacheManager.setCache(endpoint: request.endpoint, url: request.url, data: data)
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
    }
    
    task.resume()
  }
}
