//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 07/09/23.
//

import UIKit

/// Episode collection view cell view
final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUpLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  private func setUpLayer() {
    contentView.backgroundColor = .secondarySystemBackground
    layer.cornerRadius = 8
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.secondaryLabel.cgColor
  }
  
  func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) { }
}
