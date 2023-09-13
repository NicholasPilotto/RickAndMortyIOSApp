//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationViewController: UIViewController {
  private let locationView = RMLocationView()
  
  private let viewModel = RMLocationViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Locations"
    view.backgroundColor = .systemBackground
    
    view.addSubviews(locationView)
    
    addContraints()
    
    addSearchButton()
  }
  
  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)
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
  
  @objc private func didTapSearch() { }
}
