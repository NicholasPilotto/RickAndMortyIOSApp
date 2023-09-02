//
//  RMCharacterInformationCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
  static let identifier = "RMCharacterInfoCollectionViewCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstraints() {}
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  public func configure(with viewModel: RMCharacterInfoCellViewModel) { }
}
