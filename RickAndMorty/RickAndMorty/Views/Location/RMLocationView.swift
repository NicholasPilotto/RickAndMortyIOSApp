//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 13/09/23.
//

import UIKit

class RMLocationView: UIView {
  private var viewModel: RMLocationViewModel? {
    didSet {
      spinner.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      
      UIView.animate(withDuration: 0.3) {
        self.tableView.alpha = 1
      }
    }
  }
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.alpha = 0
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews(tableView, spinner)
    
    spinner.startAnimating()
    
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  public func configure(with viewModel: RMLocationViewModel) { }
}
