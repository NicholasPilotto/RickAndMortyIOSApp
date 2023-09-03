//
//  RMCharacterPhotoCellViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import Foundation

final class RMCharacterPhotoCellViewModel {
  private let imageUrl: URL?
  
  init(imageUrl: URL?) {
    self.imageUrl = imageUrl
  }
  
  /// Fetch character detail image
  /// - Parameter completion: Completion handler block
  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let imageUrl = imageUrl else {
      completion(.failure(URLError(.badURL)))
      return
    }
    
    RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
  }
}
