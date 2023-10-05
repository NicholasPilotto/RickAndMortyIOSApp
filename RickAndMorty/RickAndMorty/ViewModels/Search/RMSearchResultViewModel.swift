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


  /// Fetch more search results from pagination link.
  public func fetchAdditionalResults(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
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
}

enum RMSearchResultType {
  case characters([RMCharacterCollectionViewCellViewModel])
  case episodes([RMCharacterEpisodeCellViewModel])
  case locations([RMLocationTableViewCellViewModel])
}
