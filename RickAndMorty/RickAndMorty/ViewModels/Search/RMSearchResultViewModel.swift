//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/09/23.
//

import Foundation

enum RMSearchResultViewModel {
  case characters([RMCharacterCollectionViewCellViewModel])
  case episodes([RMCharacterEpisodeCellViewModel])
  case locations([RMLocationTableViewCellViewModel])
}
