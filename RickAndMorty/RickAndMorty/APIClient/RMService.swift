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
  
  private init() {}
  
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
  }
}
