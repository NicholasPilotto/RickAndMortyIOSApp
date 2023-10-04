//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import Foundation

final class RMSearchViewViewModel {
  private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
  private var searchText: String = ""

  private var registerOptionChangeBlock: (((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void)?

  private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
  private var noSearchResultHandler: (() -> Void)?

  private var searchResultModel: Codable?

  /// Search configuration property
  public let config: RMSearchConfig

  // MARK: - Initializers

  init(config: RMSearchConfig) {
    self.config = config
  }

  // MARK: - Private methods

  private func makeSearchApiCall<T: Codable>(_ type: T.Type, request: RMRequest) {
    // calling request
    RMService.shared.execute(request, expecting: type) { [weak self] result in
      switch result {
        case .success(let model):
          self?.processSearcResults(model: model)
        case .failure:
          self?.handleNoResults()
      }
    }
  }

  private func processSearcResults(model: Codable) {
    var resultsVM: RMSearchResultViewModel?

    if let characterModels = model as? RMGetAllCharactersResponse {
      resultsVM = .characters(characterModels.results.compactMap {
        return RMCharacterCollectionViewCellViewModel(
          characterName: $0.name,
          characterStauts: $0.status,
          characterImageUrl: URL(string: $0.image)
        )
      })
    } else if let episodeModels = model as? RMGetAllEpisodesResponse {
      resultsVM = .episodes(episodeModels.results.compactMap {
        return RMCharacterEpisodeCellViewModel(episodeDataUrl: URL(string: $0.url))
      })
    } else if let locationModels = model as? RMGetAllLocationsResponse {
      resultsVM = .locations(locationModels.results.compactMap {
        return RMLocationTableViewCellViewModel(location: $0)
      })
    }

    if let results = resultsVM {
      self.searchResultModel = model
      self.searchResultHandler?(results)
    } else {
      self.handleNoResults()
    }
  }

  private func handleNoResults() {
    self.noSearchResultHandler?()
  }

  // MARK: - Public methods

  /// Set value in option map
  /// - Parameters:
  ///   - value: value to store into the map
  ///   - option: key pointing to the value
  public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOptions) {
    optionMap[option] = value
    let tuple = (option, value)
    self.registerOptionChangeBlock?(tuple)
  }

  /// Block executed when option is changed
  /// - Parameter block: Callback
  public func registerOptionChangeBlock(
    _ block: @escaping ((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void
  ) {
    self.registerOptionChangeBlock = block
  }

  /// Set query text
  /// - Parameter text: Search query parameters
  public func set(query text: String) {
    self.searchText = text
  }

  /// Search characters, episodes, locations
  public func executeSearch() {
    guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
      return
    }

    var queryParams: [URLQueryItem] = [
      URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
    ]

    // appending query params
    queryParams.append(contentsOf: optionMap.enumerated().compactMap {
      let argument = $0.element.key.queryArgument
      let value = $0.element.value
      return URLQueryItem(name: argument, value: value)
    })

    // creating request
    let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)

    switch config.type.endpoint {
      case .character:
        makeSearchApiCall(RMGetAllCharactersResponse.self, request: request)
      case .episode:
        makeSearchApiCall(RMGetAllEpisodesResponse.self, request: request)
      case .location:
        makeSearchApiCall(RMGetAllLocationsResponse.self, request: request)
    }
  }

  /// Register block. This block is called when the publisher gets the result from
  /// the API call.
  /// - Parameter block: Subscriber event handler block
  public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
    self.searchResultHandler = block
  }

  /// Register block. This block is called when the publisher gets called from
  /// the API call when there are no results. It can happen when we are searching
  /// for something that does not exist or search went wrong.
  /// - Parameter block: Subscriber event handler block.
  public func registerNoSearchResultHandler(_ block: @escaping () -> Void) {
    self.noSearchResultHandler = block
  }

  /// Get location at particular index if it exists, nil otherwise
  /// - Parameter index: Index of the desired location
  /// - Returns: Location found
  public func locationSearchResult(at index: Int) -> RMLocation? {
    guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
      return nil
    }

    return searchModel.results[index]
  }
}
