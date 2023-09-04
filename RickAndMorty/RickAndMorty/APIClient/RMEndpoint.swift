//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import Foundation

/// Represents unique API endpoint
@frozen
enum RMEndpoint: String, Hashable, CaseIterable {
  /// endpoint to get character info
  case character
  /// endpoint to get location info
  case location
  /// endpoint to get episode info
  case episode
}
