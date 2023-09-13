//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 13/09/23.
//

import Foundation

final class RMLocationViewModel {
  private var locations: [RMLocation] = []
  
  private var cellViewModels: [String] = []
  
  private var hasMoreResults: Bool {
    return false
  }
  
  init() { }
  
  public func fetchLocation() {
    RMService.shared.execute(.listLocationsRequests, expecting: String.self) { result in
      switch result {
        case .success(let success):
          break
        case .failure(let failure):
          break
      }
    }
  }
}
