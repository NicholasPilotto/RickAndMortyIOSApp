//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import Foundation

/// Object that represents a single API call
final class RMRequest {
  /// API constants
  private enum Constants {
    static let baseUrl = "https://rickandmortyapi.com/api"
  }
  
  /// Desired endpoint
  private let endpoint: RMEndpoint
  /// Path components API, if any
  private let pathComponents: Set<String>
  /// Query arguments API, if any
  private let queryParameters: [URLQueryItem]
  
  /// Constructed URL for the API request in string format
  private var urlString: String {
    var string = Constants.baseUrl
    string += "/"
    string += endpoint.rawValue
    
    if !pathComponents.isEmpty {
      string += "/"
      pathComponents.forEach {
        string += "\($0)"
      }
    }
    
    if !queryParameters.isEmpty {
      string += "?"
      let argumentString = queryParameters.compactMap {
        guard let value = $0.value else {
          return nil
        }
        
        return "\($0.name)=\(value)"
      }
      .joined(separator: "&")
      
      string += argumentString
    }
    
    return string
  }
  
  /// Computed and constructed API URL
  public var url: URL? {
    return URL(string: urlString)
  }
  
  /// Desired HTTP method
  public let httpMethod = "GET"
  
  /// Request object initializer
  /// - Parameters:
  ///   - endpoint: target endpoint
  ///   - pathComponents: collection of path components
  ///   - queryParameters: colleciton of query parameters
  public init(endpoint: RMEndpoint, pathComponents: Set<String> = [], queryParameters: [URLQueryItem] = []) {
    self.endpoint = endpoint
    self.pathComponents = pathComponents
    self.queryParameters = queryParameters
  }
}
