//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

class RMSearchView: UIView {
  private let viewModel: RMSearchViewViewModel
  
  private let searchInputView = RMSearchInputView()
  private let noResultsView = RMNoSearchResultsView()
  
  init(frame: CGRect, viewModel: RMSearchViewViewModel) {
    self.viewModel = viewModel

    super.init(frame: frame)
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubviews(noResultsView, searchInputView)
    
    addConstraints()
    
    searchInputView.configure(with: .init(type: viewModel.config.type))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
      searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
      searchInputView.heightAnchor.constraint(equalToConstant: 110),
      
      noResultsView.widthAnchor.constraint(equalToConstant: 150),
      noResultsView.heightAnchor.constraint(equalToConstant: 150),
      noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}

// MARK: CollectionView delegate and datasource methods

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}
