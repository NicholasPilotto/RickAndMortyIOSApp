//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/08/23.
//

import UIKit

/// Episode detail view controller class
final class RMCharacterDetailViewViewModel {
  private let character: RMCharacter

  /// Represents all episode urls where this character is present
  public var episodes: [String] {
    self.character.episode
  }

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
        .init(type: .status, value: character.status.rawValue),
        .init(type: .gender, value: character.gender.rawValue),
        .init(type: .type, value: character.type),
        .init(type: .species, value: character.species),
        .init(type: .origin, value: character.origin.name),
        .init(type: .location, value: character.location.name),
        .init(type: .created, value: character.created),
        .init(type: .episodeCount, value: "\(character.episode.count)")
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
      widthDimension: .fractionalWidth(UIDevice.isIphone ? 0.5 : 0.25),
      heightDimension: .fractionalHeight(1.0))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(150)
      ),
      subitems: UIDevice.isIphone ? [item, item] : [item, item, item, item]
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
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(UIDevice.isIphone ? 0.8 : 0.4),
        heightDimension: .absolute(150)
      ),
      subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging

    return section
  }
}
