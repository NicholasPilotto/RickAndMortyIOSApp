//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

final class RMSearchInputView: UIView {
  private let searchBar: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "Search"
    bar.translatesAutoresizingMaskIntoConstraints = false
    return bar
  }()
  
  private var viewModel: RMSearchInputViewViewModel? {
    didSet {
      guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
        return
      }
      
      let options = viewModel.options
      createOptionsSelectionView(options: options)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubviews(searchBar)
    
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 3),
      searchBar.leftAnchor.constraint(equalTo: leftAnchor),
      searchBar.rightAnchor.constraint(equalTo: rightAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 55)
    ])
  }
    
  private func createOptionsSelectionView(options: [RMSearchInputViewViewModel.DynamicOptions]) {
//    for option in options { }
  }

  /// Configure view with view model
  /// - Parameter viewModel: view model that manages view
  public func configure(with viewModel: RMSearchInputViewViewModel) {
    searchBar.placeholder = viewModel.searchPlaceholderText
  }
}
