//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import Foundation

final class RMSearchViewViewModel {
  private var optionMap: [RMSearchInputViewViewModel.DynamicOptions: String] = [:]
  private var searchText: String = String()
  
  private var registerOptionChangeBlock: (((RMSearchInputViewViewModel.DynamicOptions, String)) -> Void)?
  
  /// Search configuration property
  public let config: RMSearchConfig
  
  init(config: RMSearchConfig) {
    self.config = config
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
  
  /// Search something
  public func executeSearch() { }
}
