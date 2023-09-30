//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
  func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)

  func rmSearchResultsView(_ resultsView: RMSearchView, didSelectLocation location: RMLocation)
}

class RMSearchView: UIView {
  private let viewModel: RMSearchViewViewModel
  
  private let searchInputView = RMSearchInputView()
  private let noResultsView = RMNoSearchResultsView()
  private let resultsView = RMSearchResultsView()

  weak public var delegate: RMSearchViewDelegate?
  
  init(frame: CGRect, viewModel: RMSearchViewViewModel) {
    self.viewModel = viewModel

    super.init(frame: frame)
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false

    resultsView.delegate = self

    addSubviews(resultsView, noResultsView, searchInputView)

    addConstraints()
    
    searchInputView.configure(with: .init(type: viewModel.config.type))
    searchInputView.delegate = self
    
    setUpHandlers(viewModel: viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private methods
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      // input view
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
      searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
      searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 100),
      
      // results view
      resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
      resultsView.leftAnchor.constraint(equalTo: leftAnchor),
      resultsView.rightAnchor.constraint(equalTo: rightAnchor),
      resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),

      // no results view
      noResultsView.widthAnchor.constraint(equalToConstant: 150),
      noResultsView.heightAnchor.constraint(equalToConstant: 150),
      noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  private func setUpHandlers(viewModel: RMSearchViewViewModel) {
    viewModel.registerOptionChangeBlock { tuple in
      self.searchInputView.update(option: tuple.0, value: tuple.1)
    }

    viewModel.registerSearchResultHandler { [weak self] result in
      DispatchQueue.main.async {
        self?.resultsView.configure(with: result)
        self?.noResultsView.isHidden = true
        self?.resultsView.isHidden = false
      }
    }

    viewModel.registerNoSearchResultHandler { [weak self] in
      DispatchQueue.main.async {
        self?.noResultsView.isHidden = false
        self?.resultsView.isHidden = true
      }
    }
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

// MARK: - RMSearchInputView delegate

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

// MARK: - RMSearchResultsView delegate

extension RMSearchView: RMSearchResultsDelegate {
  func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
    guard let locationModel = viewModel.locationSearchResult(at: index) else {
      return
    }

    delegate?.rmSearchResultsView(self, didSelectLocation: locationModel)
  }
}
