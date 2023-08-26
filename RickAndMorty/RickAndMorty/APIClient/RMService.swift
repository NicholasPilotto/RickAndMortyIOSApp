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
    guard let urlRequest = self.request(from: request) else {
      completion(.failure(RMServiceError.failedToCreateRequest))
      return
    }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? RMServiceError.failedToGetData))
        return
      }
      
      do {
        let result = try JSONDecoder().decode(type.self, from: data)
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
    }
    
    task.resume()
  }
}
