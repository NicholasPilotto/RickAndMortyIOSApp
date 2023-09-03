//
//  RMCharacterInformationCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
  static let identifier = "RMCharacterInfoCollectionViewCell"
  
  private let titleContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .tertiarySystemBackground
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .medium)
    return label
  }()
  
  private let valueLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .light)
    label.numberOfLines = 0
    return label
  }()
  
  private let iconImageView: UIImageView = {
    let icon = UIImageView()
    icon.translatesAutoresizingMaskIntoConstraints = false
    icon.contentMode = .scaleAspectFit
    return icon
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 8
    contentView.layer.masksToBounds = true
    contentView.addSubviews(titleContainerView, valueLabel, iconImageView)
    titleContainerView.addSubviews(titleLabel)
    
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      titleContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      titleContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
      
      titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
      titleLabel.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor),
      titleLabel.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
      
      iconImageView.heightAnchor.constraint(equalToConstant: 30),
      iconImageView.widthAnchor.constraint(equalToConstant: 30),
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
      iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
      
      valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
      valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
      valueLabel.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor)
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    valueLabel.text = nil
    titleLabel.text = nil
    iconImageView.image = nil
    iconImageView.tintColor = .label
    titleLabel.textColor = .label
  }
  
  public func configure(with viewModel: RMCharacterInfoCellViewModel) {
    titleLabel.text = viewModel.title
    valueLabel.text = viewModel.displayValue
    iconImageView.image = viewModel.iconImage
    iconImageView.tintColor = viewModel.tintColor
    titleLabel.textColor = viewModel.tintColor
  }
}
