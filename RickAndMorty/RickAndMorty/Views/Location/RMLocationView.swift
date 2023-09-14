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
    table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
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
    configureTable()
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
  
  public func configure(with viewModel: RMLocationViewModel) {
    self.viewModel = viewModel
  }
  
  private func configureTable() {
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension RMLocationView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension RMLocationView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.cellViewModels.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellViewModels = viewModel?.cellViewModels else {
      fatalError("CellViewModels is empty or null")
    }
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RMLocationTableViewCell.cellIdentifier,
      for: indexPath) as? RMLocationTableViewCell else {
      fatalError("Cannot dequeue RMLocationTableViewCell")
    }
    var content = cell.defaultContentConfiguration()
    content.secondaryText = cellViewModels[indexPath.row].name
    cell.contentConfiguration = content
    return cell
  }
}
