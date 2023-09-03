//
//  RMCharacterInfoCellViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import Foundation

final class RMCharacterInfoCellViewModel {
  private let value: String
  private let title: String
  
  init(value: String, title: String) {
    self.value = value
    self.title = title
  }
}
