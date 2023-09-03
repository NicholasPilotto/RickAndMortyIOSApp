//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
  static let identifier = "RMCharacterEpisodeCollectionViewCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .systemBlue
    contentView.layer.cornerRadius = 8
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstraints() {}
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  public func configure(with viewModel: RMCharacterEpisodeCellViewModel) {
    viewModel.registerForData { data in
      print(String(describing: data))
    }
    
    viewModel.fetchEpisode()
  }
}
