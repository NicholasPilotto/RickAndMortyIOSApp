//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/08/23.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {
  /// Name of the current character
  public let characterName: String
  private let characterStauts: RMCharacterStatus
  private let characterImageUrl: URL?
  
  /// Represents the status of the current character
  public var characterStatusText: String {
    return characterStauts.rawValue
  }
  
  init(characterName: String, characterStauts: RMCharacterStatus, characterImageUrl: URL?) {
    self.characterName = characterName
    self.characterStauts = characterStauts
    self.characterImageUrl = characterImageUrl
  }
  
  /// Get the image of the current character
  /// - Parameter completion: completion handler of the request
  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = characterImageUrl else {
      completion(.failure(URLError(.badURL)))
      return
    }
    
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error ?? URLError(.badServerResponse)))
        return
      }
      
      completion(.success(data))
    }
    
    task.resume()
  }
}
