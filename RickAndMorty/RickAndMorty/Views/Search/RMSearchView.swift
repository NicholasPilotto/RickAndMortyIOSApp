//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
  func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
}

class RMSearchView: UIView {
  private let viewModel: RMSearchViewViewModel
  
  private let searchInputView = RMSearchInputView()
  private let noResultsView = RMNoSearchResultsView()
  
  weak public var delegate: RMSearchViewDelegate?
  
  init(frame: CGRect, viewModel: RMSearchViewViewModel) {
    self.viewModel = viewModel

    super.init(frame: frame)
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubviews(noResultsView, searchInputView)
    
    addConstraints()
    
    searchInputView.configure(with: .init(type: viewModel.config.type))
    searchInputView.delegate = self
    
    viewModel.registerOptionChangeBlock { tuple in
      self.searchInputView.update(option: tuple.0, value: tuple.1)
    }
    
    viewModel.registerSearchResultHandler { results in
      print(results)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private methods
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
      searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
      searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 100),
      
      noResultsView.widthAnchor.constraint(equalToConstant: 150),
      noResultsView.heightAnchor.constraint(equalToConstant: 150),
      noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  // MARK: - Public methods
  
  public func presentKeyboard() {
    searchInputView.presentKeyboard()
  }
}

// MARK: CollectionView delegate and datasource methods

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}

// MARK: RMSearchInputView delegate

extension RMSearchView: RMSearchInputViewDelegate {
  func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
    delegate?.rmSearchView(self, didSelectOption: option)
  }
  
  func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
    viewModel.set(query: text)
  }
  
  func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
    viewModel.executeSearch()
  }
}
