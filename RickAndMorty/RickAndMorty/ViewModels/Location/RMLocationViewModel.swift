//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 13/09/23.
//

import Foundation

// RMLocationView model delegate
protocol RMLocationViewModelDelegate: AnyObject {
  func didFetchInitialLocations()
}

// Locatin view model class
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

  // MARK: - Public variables

  /// Array of cell view models
  public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []

  /// RMLocationViewModelDelegate weak reference
  public weak var delegate: RMLocationViewModelDelegate?

  /// Check if should show load more data indicator
  public var shouldShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }

  /// Check if we are currently downloading more locations
  public var isLoadingMoreLocations = false

  // MARK: - Initializers

  init() { }

  // MARK: - Public methods

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
            // TODO: Handle error
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

  /// Paginate if additional episodes are needed
  public func fetchAdditionalLocations() {
    guard !isLoadingMoreLocations else {
      return
    }

    guard let nextUrlString = apiInfo?.next,
      let url = URL(string: nextUrlString) else {
      return
    }

    isLoadingMoreLocations = true

    guard let rmRequest = RMRequest(url: url) else {
      isLoadingMoreLocations = false
      return
    }

    RMService.shared.execute(
      rmRequest,
      expecting: RMGetAllLocationsResponse.self) { [weak self] result in
        switch result {
          case .success(let responseModel):
            let moreResults = responseModel.results
            self?.apiInfo = responseModel.info

            self?.cellViewModels.append(contentsOf: moreResults.compactMap {
              return .init(location: $0)
            })

            DispatchQueue.main.async {
              self?.isLoadingMoreLocations = false
            }
          case .failure(let failure):
            print(failure)
            self?.isLoadingMoreLocations = false
        }
    }
  }
}
