//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/10/23.
//

import UIKit

final class RMTableLoadingFooterView: UIView {
  // MARK: - Private variables
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()

  // MARK: Initializer

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(spinner)

    addConstraints()

    spinner.startAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private methods

  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.heightAnchor.constraint(equalToConstant: 55),
      spinner.widthAnchor.constraint(equalToConstant: 55),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
