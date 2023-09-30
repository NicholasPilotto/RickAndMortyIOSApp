//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 29/09/23.
//

import UIKit

protocol RMSearchResultsDelegate: AnyObject {
  func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

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

  private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []

  public weak var delegate: RMSearchResultsDelegate?

  // MARK: - Initializers

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
        setUpCollectionView()
      case .locations(let viewModels):
        setUpTableView(viewModels: viewModels)
    }
  }

  private func setUpCollectionView() { }

  private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = false
    self.locationCellViewModels = viewModels
    tableView.reloadData()
  }

  // MARK: - Public methods

  /// Configure current view with its view model class.
  /// - Parameter viewModel: view model class used to configure view
  public func configure(with viewModel: RMSearchResultViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - UITableView delegate and datasource methods

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locationCellViewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RMLocationTableViewCell.cellIdentifier,
      for: indexPath) as? RMLocationTableViewCell else {
      fatalError("Failed to dequeue RMLocationTableViewCell")
    }
    cell.configure(with: locationCellViewModels[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
  }
}
