//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 30/08/23.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
  static let identifier = "RMFooterLoadingCollectionReusableView"
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.hidesWhenStopped = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBackground
    addSubviews(spinner)
    addContraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addContraints() {
    NSLayoutConstraint.activate([
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  public func startAnimating() {
    spinner.startAnimating()
  }
}
