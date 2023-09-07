//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 04/09/23.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
  func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
  // MARK: private vars
  private let endpointUrl: URL?
  private var dataTuple: (RMEpisode, [RMCharacter])? {
    didSet {
      delegate?.didFetchEpisodeDetails()
    }
  }
  
  // MARK: public vars
  
  /// delegate property
  public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
  
  enum SectionType {
    case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
    case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
  }
  
  init(endpointUrl: URL?) {
    self.endpointUrl = endpointUrl
    
    fetchEpisodeData()
  }
  
  /// Fetch episode related character
  /// - Parameter episode: episode whose characters we are interested in
  private func fetchRelatedCharacters(episode: RMEpisode) {
    let requests: [RMRequest] = episode.characters.compactMap {
      return URL(string: $0)
    }
      .compactMap {
        return RMRequest(url: $0)
      }
    
    // 10 parallel request
    let group = DispatchGroup()
    var characters: [RMCharacter] = []
    
    for request in requests {
      group.enter()
      
      RMService.shared.execute(request, expecting: RMCharacter.self) { result in
        defer {
          group.leave()
        }
        
        switch result {
          case .success(let model):
            characters.append(model)
          case .failure:
            break
        }
      }
    }
    
    group.notify(queue: .main) {
      self.dataTuple = (
        episode,
        characters
      )
    }
  }
  
  /// Fetch backing episode model
  public func fetchEpisodeData() {
    guard let url = endpointUrl, let request = RMRequest(url: url) else {
      return
    }
    
    RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
      switch result {
        case .success(let model):
          self?.fetchRelatedCharacters(episode: model)
        case .failure(let failure):
          print(failure)
      }
    }
  }
}
