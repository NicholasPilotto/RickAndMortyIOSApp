//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import Foundation

struct RMCharacter: Codable, Hashable {
  let id: Int
  let name: String
  let status: RMCharacterStatus
  let species: String
  let type: String
  let gender: RMCharacterGender
  let origin: RMOrigin
  let location: RMSingleLocation
  let image: String
  let episode: [String]
  let url: String
  let created: String

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self)
  }

  static func == (lhs: RMCharacter, rhs: RMCharacter) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
