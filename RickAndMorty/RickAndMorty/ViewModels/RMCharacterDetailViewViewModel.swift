//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/08/23.
//

import UIKit

final class RMCharacterDetailViewViewModel {
  private let character: RMCharacter
  
  enum SectionType {
    case photo(viewModel: RMCharacterPhotoCellViewModel)
    case information(viewModels: [RMCharacterInfoCellViewModel])
    case episodes(viewModels: [RMCharacterEpisodeCellViewModel])
  }
  
  /// Type of the section
  public var sections: [SectionType] = []
  
  /// Computed property to get the title of the view
  public var title: String {
    character.name.uppercased()
  }
  
  init(character: RMCharacter) {
    self.character = character
    setUpSections()
  }
  
  private func setUpSections() {
    sections = [
      .photo(viewModel: .init(imageUrl: URL(string: character.image))),
      .information(viewModels: [
        .init(value: character.status.rawValue, title: "Status"),
        .init(value: character.gender.rawValue, title: "Gender"),
        .init(value: character.type, title: "Type"),
        .init(value: character.species, title: "Species"),
        .init(value: character.origin.name, title: "Origin"),
        .init(value: character.location.name, title: "Location"),
        .init(value: character.created, title: "Created"),
        .init(value: "\(character.episode.count)", title: "Total episode")
      ]),
      .episodes(viewModels: character.episode.compactMap {
        return RMCharacterEpisodeCellViewModel(episodeDataUrl: URL(string: $0))
      })
    ]
  }
  
  // MARK: layout
  
  /// Create collection view layout section for character photo cell
  /// - Returns: NSCollectionLayoutSection for character photo
  public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.5)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    
    return section
  }
  
  
  /// Create collection view layout section for character information cell
  /// - Returns: NSCollectionLayoutSection for character information
  public func createInformationSectionLayout() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalHeight(1.0))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 2, trailing: 2)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(150)
      ),
      subitems: [item, item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    
    return section
  }
  
  
  /// Create collection view layout section for character episodes cell
  /// - Returns: NSCollectionViewSection for character episodes
  public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 8)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.8),
        heightDimension: .absolute(150)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    
    return section
  }
}
