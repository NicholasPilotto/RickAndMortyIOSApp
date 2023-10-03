//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 13/09/23.
//

import UIKit

protocol RMLocationViewDelegate: AnyObject {
  func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation)
}

class RMLocationView: UIView {
  // MARK: - Private viariables
  private var viewModel: RMLocationViewModel? {
    didSet {
      spinner.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()

      UIView.animate(withDuration: 0.3) {
        self.tableView.alpha = 1
      }

      viewModel?.registerDidFinishPaginationBlock { [weak self] in
        DispatchQueue.main.async {
          self?.tableView.tableFooterView = nil
          self?.tableView.reloadData()
        }
      }
    }
  }

  private let tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.alpha = 0
    table.isHidden = true
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(
      RMLocationTableViewCell.self,
      forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
    )
    return table
  }()

  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()

  // MARK: - Public variables

  public weak var delegate: RMLocationViewDelegate?

  // MARK: - Initializers

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

  // MARK: - Private methods

  private func addConstraints() {
    NSLayoutConstraint.activate([
      // spinner constraints
      spinner.heightAnchor.constraint(equalToConstant: 100),
      spinner.widthAnchor.constraint(equalToConstant: 100),
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

      // table view constraints
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func configureTable() {
    tableView.dataSource = self
    tableView.delegate = self
  }

  private func showLoadingIndicator() {
    let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
    tableView.tableFooterView = footer
  }

  // MARK: Public methods

  public func configure(with viewModel: RMLocationViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - UITableView delegate

extension RMLocationView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let locationModel = viewModel?.location(at: indexPath.row) else {
      return
    }

    delegate?.rmLocationView(self, didSelect: locationModel)
  }
}

// MARK: - UITable view dataSource

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
    cell.configure(with: cellViewModels[indexPath.row])
    return cell
  }
}

// MARK: - UIScrollView delegate

extension RMLocationView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let viewModel = viewModel,
      !viewModel.cellViewModels.isEmpty,
      viewModel.shouldShowLoadMoreIndicator else {
      return
    }

    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewFixedHeight = scrollView.frame.size.height

      if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        DispatchQueue.main.async {
          self?.showLoadingIndicator()
        }

        viewModel.fetchAdditionalLocations()
      }

      timer.invalidate()
    }
  }
}
