//
//  RMNOSearchResultsView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

class RMNoSearchResultsView: UIView {
  private let viewModel = RMNoSearchResultsViewViewModel()

  private let iconView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.tintColor = .systemBlue
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  private let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    isHidden = true

    addSubviews(iconView, label)

    addConstraints()

    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      iconView.widthAnchor.constraint(equalToConstant: 90),
      iconView.heightAnchor.constraint(equalToConstant: 90),
      iconView.topAnchor.constraint(equalTo: topAnchor),
      iconView.centerXAnchor.constraint(equalTo: centerXAnchor),

      label.leftAnchor.constraint(equalTo: leftAnchor),
      label.rightAnchor.constraint(equalTo: rightAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
      label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10)
    ])
  }

  public func configure() {
    label.text = viewModel.title
    iconView.image = viewModel.image
  }
}
