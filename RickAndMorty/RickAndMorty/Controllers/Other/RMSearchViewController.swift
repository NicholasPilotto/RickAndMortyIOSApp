//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 05/09/23.
//

import UIKit

struct RMSearchConfig {
  enum `Type` {
    case character
    case episode
    case location
  }
  
  let type: `Type`
}

/// Configurable controller to search things
class RMSearchViewController: UIViewController {
  private let config: RMSearchConfig
  
  init(config: RMSearchConfig) {
    self.config = config
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search"
    view.backgroundColor = .systemBackground
  }
}
