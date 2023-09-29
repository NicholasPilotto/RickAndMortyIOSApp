//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/09/23.
//

import UIKit

/// Shows search results UI
final class RMSearchResultsView: UIView {
  private var viewModel: RMSearchResultViewModel? {
    didSet {
      self.processViewModel()
    }
  }

  private let tableView: UITableView = {
    let table = UITableView()
    table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false

    addSubviews(tableView)

    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private methods

  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func processViewModel() {
    guard let viewModel = self.viewModel else {
      return
    }

    switch viewModel {
      case .characters(let viewModels):
        print(viewModels)
        setUpCollectionView()
      case .episodes(let viewModels):
        print(viewModels)
        setUpTableView()
      case .locations(let viewModels):
        print(viewModels)
        setUpCollectionView()
    }
  }

  private func setUpCollectionView() { }

  private func setUpTableView() {
    tableView.isHidden = false
  }

  // MARK: - Public methods


  /// Configure current view with its view model class.
  /// - Parameter viewModel: view model class used to configure view
  public func configure(with viewModel: RMSearchResultViewModel) {
    self.viewModel = viewModel
  }
}
