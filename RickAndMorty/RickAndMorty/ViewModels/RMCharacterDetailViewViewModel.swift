//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/08/23.
//

import UIKit

final class RMCharacterDetailViewViewModel {
  private let character: RMCharacter
  
  enum SectionType: CaseIterable {
    case photo
    case information
    case episodes
  }
  
  /// Type of the section
  public let sections = SectionType.allCases
  
  /// Computed property to get the title of the view
  public var title: String {
    character.name.uppercased()
  }
  
  init(character: RMCharacter) {
    self.character = character
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
