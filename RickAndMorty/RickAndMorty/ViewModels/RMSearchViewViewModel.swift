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
  
  private var searchResultHandler: (() -> Void)?
  
  /// Search configuration property
  public let config: RMSearchConfig
  
  // MARK: - Initializers
  
  init(config: RMSearchConfig) {
    self.config = config
  }
  
  // MARK: - Private methods
  
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
    var queryParams: [URLQueryItem] = [
      URLQueryItem(name: "name", value: searchText)
    ]
    
    // appending query params
    queryParams.append(contentsOf: optionMap.enumerated().compactMap {
      let argument = $0.element.key.queryArgument
      let value = $0.element.value
      return URLQueryItem(name: argument, value: value)
    })

    // creating request
    let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
    
    // calling request
    RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { result in
      switch result {
        case .success(let model):
          print(String(describing: model))
        case .failure(let failure):
          print(String(describing: failure))
      }
    }
  }
  
  /// Register block. This block is called when the publisher gets the result from
  /// the API call.
  /// - Parameter block: Subscriber event handler block
  public func registerSearchResultHandler(_ block: @escaping () -> Void) {
    self.searchResultHandler = block
  }
}
