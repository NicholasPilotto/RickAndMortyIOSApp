//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationViewController: UIViewController, RMLocationViewModelDelegate, RMLocationViewDelegate {
  private let locationView = RMLocationView()

  private let viewModel = RMLocationViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Locations"
    view.backgroundColor = .systemBackground

    locationView.delegate = self

    view.addSubviews(locationView)

    addContraints()

    addSearchButton()

    viewModel.delegate = self
    viewModel.fetchLocation()
  }

  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search,
      target: self,
      action: #selector(didTapSearch)
    )
  }

  private func addContraints() {
    NSLayoutConstraint.activate([
      locationView.topAnchor.constraint(equalTo: view.topAnchor),
      locationView.leftAnchor.constraint(equalTo: view.leftAnchor),
      locationView.rightAnchor.constraint(equalTo: view.rightAnchor),
      locationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc private func didTapSearch() {
    let viewController = RMSearchViewController(config: .init(type: .location))
    viewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(viewController, animated: true)
  }

  // MARK: LocationViewModel delegate
  func didFetchInitialLocations() {
    locationView.configure(with: viewModel)
  }

  // MARK: LocationView delegate
  func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
    let viewController = RMLocationDetailViewController(location: location)
    viewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(viewController, animated: true)
  }
}
