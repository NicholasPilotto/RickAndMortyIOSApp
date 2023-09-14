//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 14/09/23.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable, Equatable {
  private let location: RMLocation
  
  /// Location name
  public var name: String {
    return location.name
  }
  
  /// Location type
  public var type: String {
    location.type
  }
  
  /// Location dimension
  public var dimension: String {
    location.dimension
  }
  
  init(location: RMLocation) {
    self.location = location
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(location.id)
    hasher.combine(dimension)
    hasher.combine(location.type)
  }
  
  static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
