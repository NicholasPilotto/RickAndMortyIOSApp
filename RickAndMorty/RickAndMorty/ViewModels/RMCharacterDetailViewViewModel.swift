//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/08/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
  private let character: RMCharacter
  
  /// Computed property to get the title of the view
  public var title: String {
    character.name.uppercased()
  }
  
  init(character: RMCharacter) {
    self.character = character
  }
}
