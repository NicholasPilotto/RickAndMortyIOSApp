//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 05/09/23.
//

import UIKit

/// Configuration for search session
struct RMSearchConfig {
  /// Identify what we are searching for
  /// - Parameter character: search character by name, status or gender
  /// - Parameter episode: search episode by name
  /// - Parameter location: search location by name or type
  enum `Type` {
    case character
    case episode
    case location
    
    var title: String {
      switch self {
        case .character:
          return "Search Character"
        case .episode:
          return "Search Episode"
        case .location:
          return "Search Location"
      }
    }
  }
  
  let type: `Type`
}

/// Configurable controller to search things
class RMSearchViewController: UIViewController {
  private let searchView: RMSearchView
  private let viewModel: RMSearchViewViewModel
  
  init(config: RMSearchConfig) {
    let viewModel = RMSearchViewViewModel(config: config)
    self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel.config.type.title
    view.backgroundColor = .systemBackground
    
    view.addSubviews(searchView)
    
    addConstraints()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Search",
      style: .done,
      target: self,
      action: #selector(didTapExecuteSearch))
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc private func didTapExecuteSearch() { }
}
