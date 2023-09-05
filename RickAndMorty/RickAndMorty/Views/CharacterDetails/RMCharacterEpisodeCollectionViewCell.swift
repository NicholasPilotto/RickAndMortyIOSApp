//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
  static let identifier = "RMCharacterEpisodeCollectionViewCell"
  
  private let seasonLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .regular)
    return label
  }()
  
  private let airDateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 18, weight: .light)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .tertiarySystemBackground
    
    setUpLayer()
    
    contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
    
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpLayer() {
    contentView.layer.cornerRadius = 8
    contentView.layer.borderWidth = 2
  }
  
  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
      seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10),
      seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
      
      nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
      nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
      nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
      nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
      
      airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
      airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
      airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
      airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    seasonLabel.text = nil
    nameLabel.text = nil
    airDateLabel.text = nil
  }
  
  public func configure(with viewModel: RMCharacterEpisodeCellViewModel) {
    viewModel.registerForData { [weak self] data in
      DispatchQueue.main.async {
        self?.seasonLabel.text = "Episode: " + data.episode
        self?.nameLabel.text = data.name
        self?.airDateLabel.text = "Aired on: " + data.air_date
      }
    }
    
    viewModel.fetchEpisode()
    
    contentView.layer.borderColor = viewModel.borderColor.cgColor
  }
}
