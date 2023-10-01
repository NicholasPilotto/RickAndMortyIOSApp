//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 05/09/23.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
  struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
  }

  let info: Info
  let results: [RMEpisode]
}
