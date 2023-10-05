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

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.isHidden = true
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.register(
      RMCharacterCollectionViewCell.self,
      forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
    )
    collection.register(
      RMCharacterEpisodeCollectionViewCell.self,
      forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier
    )
    collection.register(
      RMFooterLoadingCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
    )
    return collection
  }()

  /// TableView viewmodels
  private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
  /// CollectionView viewmodels
  private var collectionViewCellViewModels: [any Hashable] = []

  public weak var delegate: RMSearchResultsDelegate?

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false

    addSubviews(tableView, collectionView)

    addConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private methods

  private func addConstraints() {
    NSLayoutConstraint.activate([
      // table view
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

      // collection view
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func processViewModel() {
    guard let viewModel = self.viewModel else {
      return
    }

    switch viewModel.results {
      case .characters(let viewModels):
        self.collectionViewCellViewModels = viewModels
        setUpCollectionView()
      case .episodes(let viewModels):
        self.collectionViewCellViewModels = viewModels
        setUpCollectionView()
      case .locations(let viewModels):
        setUpTableView(viewModels: viewModels)
    }
  }

  private func setUpCollectionView() {
    tableView.isHidden = true
    collectionView.isHidden = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadData()
  }

  private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = false
    collectionView.isHidden = true
    self.locationCellViewModels = viewModels
    tableView.reloadData()
  }

  private func showLoadingIndicator() {
    let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
    tableView.tableFooterView = footer
  }

  private func handleLocationPagination(scrollView: UIScrollView) {
    guard let viewModel = viewModel,
      !locationCellViewModels.isEmpty,
      viewModel.shouldShowLoadMoreIndicator,
      !viewModel.isLoadingMoreResults else {
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

        viewModel.fetchAdditionalResults { [weak self] newResults in
          self?.tableView.tableFooterView = nil
          self?.locationCellViewModels = newResults
          self?.tableView.reloadData()
        }
      }

      timer.invalidate()
    }
  }

  private func handleCharacterPagination(scrollView: UIScrollView) { }

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

// MARK: - UICollectionView delegate

extension RMSearchResultsView: UICollectionViewDelegate,
  UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewCellViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let currentObject = collectionViewCellViewModels[indexPath.row]

    if let characterViewModel = currentObject as? RMCharacterCollectionViewCellViewModel {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
        for: indexPath
      ) as? RMCharacterCollectionViewCell else {
        fatalError("Cannot dequeue RMCharacterCollectionViewCell")
      }

      cell.configure(with: characterViewModel)
      return cell
    } else if let episodeViewModel = currentObject as? RMCharacterEpisodeCellViewModel {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
        for: indexPath
      ) as? RMCharacterEpisodeCollectionViewCell else {
        fatalError("Cannot dequeue RMCharacterCollectionViewCell")
      }

      cell.configure(with: episodeViewModel)
      return cell
    }

    return UICollectionViewCell(frame: .zero)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let currentViewModel = collectionViewCellViewModels[indexPath.row]

    let bounds = collectionView.bounds

    if currentViewModel is RMCharacterCollectionViewCellViewModel {
      // Character size
      let width = (bounds.width - 30) / 2
      return CGSize(
        width: width,
        height: width * 1.5
      )
    }

    // Episode
    let width = bounds.width - 20
    return CGSize(
      width: width,
      height: 100
    )
  }
}

// MARK: - UIScrollView delegate

extension RMSearchResultsView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !locationCellViewModels.isEmpty {
      handleLocationPagination(scrollView: scrollView)
    } else {
      handleCharacterPagination(scrollView: scrollView)
    }
  }
}
