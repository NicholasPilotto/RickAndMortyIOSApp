//
//  RMLocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 16/09/23.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
  func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {
  // MARK: private vars
  private let endpointUrl: URL?
  private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
    didSet {
      createCellViewModel()
      delegate?.didFetchLocationDetails()
    }
  }

  // MARK: public vars

  /// delegate property
  public weak var delegate: RMLocationDetailViewViewModelDelegate?

  enum SectionType {
    case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
    case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
  }

  /// episode collection view cell view type
  public private(set) var cellViewModels: [SectionType] = []

  init(endpointUrl: URL?) {
    self.endpointUrl = endpointUrl

    fetchLocationData()
  }

  /// Fetch episode related location
  /// - Parameter location: location whose locations we are interested in
  private func fetchRelatedLocations(location: RMLocation) {
    let requests: [RMRequest] = location.residents.compactMap {
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
        location: location,
        characters: characters
      )
    }
  }

  private func createCellViewModel() {
    guard let dataTuple = dataTuple else {
      return
    }

    let location = dataTuple.location
    let characters = dataTuple.characters

    var createdString = ""
    if let date = RMCharacterInfoCellViewModel.dateFormatter.date(from: location.created) {
      createdString = RMCharacterInfoCellViewModel.shortDateFormatter.string(from: date)
    }

    cellViewModels = [
      .information(viewModels: [
        .init(title: "Location name", value: location.name),
        .init(title: "Type", value: location.type),
        .init(title: "Dimension", value: location.dimension),
        .init(title: "Created", value: createdString)
      ]),
      .characters(viewModels: characters.compactMap {
        return RMCharacterCollectionViewCellViewModel(
          characterName: $0.name,
          characterStauts: $0.status,
          characterImageUrl: URL(string: $0.image)
        )
      })
    ]
  }

  /// Fetch backing location model
  public func fetchLocationData() {
    guard let url = endpointUrl, let request = RMRequest(url: url) else {
      return
    }

    RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
      switch result {
        case .success(let model):
          self?.fetchRelatedLocations(location: model)
        case .failure(let failure):
          print(failure)
      }
    }
  }

  /// Get the nth location inside the (RMLocation, [RMCharacter]) tuple
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
