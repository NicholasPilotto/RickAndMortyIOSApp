//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 04/09/23.
//

import Foundation

final class RMEpisodeDetailViewViewModel {
  private let endpointUrl: URL?
  
  init(endpointUrl: URL?) {
    self.endpointUrl = endpointUrl
    
    fetchEpisodeData()
  }
  
  private func fetchEpisodeData() {
    guard let url = endpointUrl, let request = RMRequest(url: url) else {
      return
    }
    
    RMService.shared.execute(request, expecting: RMEpisode.self) { result in
      switch result {
        case .success(let success):
          print(success)
        case .failure(let failure):
          print(failure)
      }
    }
  }
}
