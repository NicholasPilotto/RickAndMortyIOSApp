//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for locations
final class RMLocationViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Locations"
    view.backgroundColor = .systemBackground
    
    addSearchButton()
  }
  
  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)
    )
  }
  
  @objc private func didTapSearch() { }
}
