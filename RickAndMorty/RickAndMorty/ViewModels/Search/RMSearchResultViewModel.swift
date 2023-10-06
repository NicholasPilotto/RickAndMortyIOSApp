//
//  RMSearchResultType.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/09/23.
//

import Foundation

class RMSearchResultViewModel {
  /// Results object
  public private(set) var results: RMSearchResultType

  /// Link to next page
  public var next: String?

  /// Flag used to show indicator
  public var shouldShowLoadMoreIndicator: Bool {
    return next != nil
  }
  
  /// Flag used to check if is loading more results
  public private(set) var isLoadingMoreResults = false

  init(results: RMSearchResultType, next: String?) {
    self.results = results
    self.next = next
  }


  /// Fetch more search locations from pagination link.
  public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
    guard !isLoadingMoreResults else {
      return
    }

    guard let nextUrlString = next,
      let url = URL(string: nextUrlString) else {
      return
    }

    isLoadingMoreResults = true

    guard let rmRequest = RMRequest(url: url) else {
      isLoadingMoreResults = false
      return
    }

    RMService.shared.execute(
      rmRequest,
      expecting: RMGetAllLocationsResponse.self) { [weak self] result in
        switch result {
          case .success(let responseModel):
            let moreResults = responseModel.results
            let info = responseModel.info
            self?.next = info.next

            let additionalLocations = moreResults.compactMap {
              return RMLocationTableViewCellViewModel(location: $0)
            }

            var newResults: [RMLocationTableViewCellViewModel] = []

            switch self?.results {
              case .characters:
                break
              case .episodes:
                break
              case .locations(let existingResults):
                newResults = existingResults + additionalLocations
                self?.results = .locations(newResults)
              case nil:
                break
            }

            DispatchQueue.main.async {
              self?.isLoadingMoreResults = false
              
              // Notify UI to refresh via callback
              completion(newResults)
              //              self?.didFinishPagination?()
            }
          case .failure(let failure):
            print(failure)
            self?.isLoadingMoreResults = false
        }
    }
  }

  /// Fetch more search results from pagination link.
  public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
    guard !isLoadingMoreResults else { return }
    guard let nextUrlString = next, let url = URL(string: nextUrlString) else { return }
    isLoadingMoreResults = true
    guard let rmRequest = RMRequest(url: url) else {
      isLoadingMoreResults = false
      return
    }
    switch results {
      case .characters(let existingResults):
        RMService.shared.execute(rmRequest, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
          switch result {
            case .success(let responseModel):
              let moreResults = responseModel.results
              let info = responseModel.info
              self?.next = info.next
              let additionalResults = moreResults.compactMap {
                return RMCharacterCollectionViewCellViewModel(
                  characterName: $0.name,
                  characterStauts: $0.status,
                  characterImageUrl: URL(string: $0.image)
                )
              }
              var newResults: [RMCharacterCollectionViewCellViewModel] = []
              newResults = existingResults + additionalResults
              self?.results = .characters(newResults)
              DispatchQueue.main.async {
                self?.isLoadingMoreResults = false
                completion(additionalResults) // Notify UI to refresh via callback
              }
            case .failure(let failure):
              print(failure)
              self?.isLoadingMoreResults = false
          }
        }
      case .episodes(let existingResults):
        RMService.shared.execute(rmRequest, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
          switch result {
            case .success(let responseModel):
              let moreResults = responseModel.results
              let info = responseModel.info
              self?.next = info.next
              let additionalResults = moreResults.compactMap {
                return RMCharacterEpisodeCellViewModel(episodeDataUrl: URL(string: $0.url))
              }
              var newResults: [RMCharacterEpisodeCellViewModel] = []
              newResults = existingResults + additionalResults
              self?.results = .episodes(newResults)
              DispatchQueue.main.async {
                self?.isLoadingMoreResults = false
                completion(additionalResults) // Notify UI to refresh via callback
              }
            case .failure(let failure):
              print(failure)
              self?.isLoadingMoreResults = false
          }
        }
      case .locations: break
    }
  }
}

enum RMSearchResultType {
  case characters([RMCharacterCollectionViewCellViewModel])
  case episodes([RMCharacterEpisodeCellViewModel])
  case locations([RMLocationTableViewCellViewModel])
}
