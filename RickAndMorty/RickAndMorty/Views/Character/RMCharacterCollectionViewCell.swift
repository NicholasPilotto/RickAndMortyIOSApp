//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/08/23.
//

import UIKit

/// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "RMCharacterCollectionViewCell"

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let statusLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubviews(imageView, nameLabel, statusLabel)

    addContraints()
    setUpLayer()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addContraints() {
    NSLayoutConstraint.activate([
      statusLabel.heightAnchor.constraint(equalToConstant: 30),
      nameLabel.heightAnchor.constraint(equalToConstant: 30),

      statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
      statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
      nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
      nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),

      statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
      nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),

      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3)
    ])
  }

  private func setUpLayer() {
    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 8
    contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
    contentView.layer.cornerRadius = 4
    contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    contentView.layer.shadowOpacity = 0.3
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    nameLabel.text = nil
    statusLabel.text = nil
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setUpLayer()
  }

  public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
    nameLabel.text = viewModel.characterName
    statusLabel.text = viewModel.characterStatusText

    viewModel.fetchImage { [weak self] result in
      switch result {
        case .success(let data):
          DispatchQueue.main.async {
            let image = UIImage(data: data)
            self?.imageView.image = image
          }
        case .failure(let error):
          print(error)
      }
    }
  }
}
