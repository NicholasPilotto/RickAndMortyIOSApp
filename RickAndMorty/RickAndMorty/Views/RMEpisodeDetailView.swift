//
//  RMEpisodeView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 04/09/23.
//

import UIKit

final class RMEpisodeDetailView: UIView {
  private var viewModel: RMEpisodeDetailViewViewModel?
  
  private var collectionView: UICollectionView?
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    self.collectionView = createCollectionView()
    
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() { }
  
  private func createCollectionView() -> UICollectionView {
    return UICollectionView(frame: .zero)
  }
  
  public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
    self.viewModel = viewModel
  }
}
