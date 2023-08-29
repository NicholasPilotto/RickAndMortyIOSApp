//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/08/23.
//

import UIKit

/// Controller to show info about a single character
final class RMCharacterDetailViewController: UIViewController {
  private let viewModel: RMCharacterDetailViewViewModel
  
  init(viewModel: RMCharacterDetailViewViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = viewModel.title
  }
}
