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
  private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
    didSet {
      createCellViewModel()
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
  
  /// episode collection view cell view type
  public private(set) var cellViewModels: [SectionType] = []
  
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
        episode: episode,
        characters: characters
      )
    }
  }
  
  private func createCellViewModel() {
    guard let dataTuple = dataTuple else {
      return
    }
    
    let episode = dataTuple.episode
    let characters = dataTuple.characters
    
    var createdString = ""
    if let date = RMCharacterInfoCellViewModel.dateFormatter.date(from: episode.created) {
      createdString = RMCharacterInfoCellViewModel.shortDateFormatter.string(from: date)
    }
    
    cellViewModels = [
      .information(viewModels: [
        .init(title: "Episode name", value: episode.name),
        .init(title: "Air date", value: episode.air_date),
        .init(title: "Episode", value: episode.episode),
        .init(title: "Created", value: createdString)
      ]),
      .characters(viewModel: characters.compactMap {
        return RMCharacterCollectionViewCellViewModel(
          characterName: $0.name,
          characterStauts: $0.status,
          characterImageUrl: URL(string: $0.image)
        )
      })
    ]
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
  
  /// Get the nth character inside the (RMEpisode, [RMCharacter]) tuple
  /// if it exists or it is presents
  /// - Parameter index: index of the character
  /// - Returns: return the character if it is presents, nil otherwise
  public func character(at index: Int) -> RMCharacter? {
    guard let dataTuple = dataTuple else {
      return nil
    }
    
    return dataTuple.characters[index]
  }
}
