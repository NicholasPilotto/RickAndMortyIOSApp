//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/08/23.
//

import UIKit

/// View for single character info
final class RMCharacterDetailView: UIView {
  var collectionView: UICollectionView?
  
  private let viewModel: RMCharacterDetailViewViewModel
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
    self.viewModel = viewModel

    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    
    let collectionView = createCollectionView()
    self.collectionView = collectionView
    addSubviews(spinner, collectionView)

    addConstrants()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstrants() {
    guard let collectionView = collectionView else {
      return
    }
    
    NSLayoutConstraint.activate([
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func createCollectionView() -> UICollectionView {
    let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      return self?.createSection(for: sectionIndex)
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }
  
  private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
    let sectiontsType = viewModel.sections
    
    switch sectiontsType[sectionIndex] {
      case .photo:
        return viewModel.createPhotoSectionLayout()
      case .information:
        return viewModel.createInformationSectionLayout()
      case .episodes:
        return viewModel.createEpisodesSectionLayout()
    }
  }
}
