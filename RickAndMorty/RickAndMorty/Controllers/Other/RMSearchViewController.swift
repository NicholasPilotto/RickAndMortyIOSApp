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
    title = config.type.title
    view.backgroundColor = .systemBackground
  }
}
