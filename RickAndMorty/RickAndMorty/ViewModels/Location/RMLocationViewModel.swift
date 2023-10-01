//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 13/09/23.
//

import Foundation

protocol RMLocationViewModelDelegate: AnyObject {
  func didFetchInitialLocations()
}

final class RMLocationViewModel {
  private var locations: [RMLocation] = [] {
    didSet {
      for location in locations {
        let cellViewModel = RMLocationTableViewCellViewModel(location: location)

        if !cellViewModels.contains(cellViewModel) {
          cellViewModels.append(cellViewModel)
        }
      }
    }
}

  private var hasMoreResults: Bool {
    return false
  }

  private var apiInfo: RMGetAllLocationsResponse.Info?

  /// Array of cell view models
  public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []

  /// RMLocationViewModelDelegate weak reference
  public weak var delegate: RMLocationViewModelDelegate?

  init() { }

  /// Fetch locations function
  public func fetchLocation() {
    RMService.shared.execute(
      .listLocationsRequests,
      expecting: RMGetAllLocationsResponse.self) { [weak self] result in
      switch result {
        case .success(let model):
          self?.apiInfo = model.info
          self?.locations = model.results
          DispatchQueue.main.async {
            self?.delegate?.didFetchInitialLocations()
          }
        case .failure(let failure):
          print(failure)
      }
    }
  }

  /// Get location at specific index
  /// - Parameter index: index of the desired location
  /// - Returns: Location if it exists in collection, `nil` otherwise
  public func location(at index: Int) -> RMLocation? {
    guard index < locations.count else {
      return nil
    }

    return self.locations[index]
  }
}
