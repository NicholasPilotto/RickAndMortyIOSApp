//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
  static let identifier = "RMCharacterPhotoCollectionViewCell"
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubviews(imageView)
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView.image = nil
  }
  
  public func configure(with viewModel: RMCharacterPhotoCellViewModel) {
    viewModel.fetchImage { [weak self] result in
      switch result {
        case .success(let data):
          DispatchQueue.main.async {
            self?.imageView.image = UIImage(data: data)
          }
        case .failure(let error):
          print(error.localizedDescription)
      }
    }
  }
}
