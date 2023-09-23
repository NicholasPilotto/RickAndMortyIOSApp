//
//  RMSearcInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import Foundation

final class RMSearchInputViewViewModel {
  private let type: RMSearchConfig.`Type`
  
  public enum DynamicOptions: String {
    case status = "Status"
    case gender = "Gender"
    case locationType = "Location type"
    
    var choises: [String] {
      switch self {
        case .status:
          return ["alive", "dead", "unknown"]
        case .gender:
          return ["male", "female", "genderless", "unknown"]
        case .locationType:
          return ["cluster", "planet", "microverse"]
      }
    }
  }
  
  /// Property to know if the current type has dynamic
  /// options.
  public var hasDynamicOptions: Bool {
    switch self.type {
      case .character, .location:
        return true
      case .episode:
        return false
    }
  }
  
  /// Property to know what option current view needs to show.
  public var options: [DynamicOptions] {
    switch self.type {
      case .character:
        return [.status, .gender]
      case .location:
        return [.locationType]
      case .episode:
        return []
    }
  }
  
  /// Property to know what is the placeholder text
  /// for the search bar.
  public var searchPlaceholderText: String {
    switch self.type {
      case .character:
        return "Character name"
      case .location:
        return "Location name"
      case .episode:
        return "Episode name"
    }
  }
  
  init(type: RMSearchConfig.`Type`) {
    self.type = type
  }
}
