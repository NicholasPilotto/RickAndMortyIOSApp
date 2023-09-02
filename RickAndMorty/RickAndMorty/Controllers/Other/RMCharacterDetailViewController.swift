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
  
  private let detailView: RMCharacterDetailView
  
  init(viewModel: RMCharacterDetailViewViewModel) {
    self.viewModel = viewModel
    self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = viewModel.title
    view.addSubviews(detailView)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action,
      target: self,
      action: #selector(didTapShared))
    addConstraints()
    
    detailView.collectionView?.delegate = self
    detailView.collectionView?.dataSource = self
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc private func didTapShared() {}
}

// MARK: UICollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
      case 0:
        return 1
      case 1:
        return 8
      case 2:
        return 20
        
      default:
        return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .systemPink
    return cell
  }
}
