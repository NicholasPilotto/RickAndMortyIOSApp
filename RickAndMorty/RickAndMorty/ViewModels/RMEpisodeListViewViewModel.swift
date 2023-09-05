//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 05/09/23.
//

import UIKit

protocol RMEpisodeListViewModelDelegate: AnyObject {
  func didLoadInitialEpisode()
  func didSelectEpisode(_ episode: RMEpisode)
  func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
}

/// View model to manage episode list business logic
final class RMEpisodeListViewViewModel: NSObject {
  public weak var delegate: RMEpisodeListViewModelDelegate?
  
  private var episodes: [RMEpisode] = [] {
    didSet {
      for episode in episodes {
        let viewModel = RMCharacterEpisodeCellViewModel(episodeDataUrl: URL(string: episode.url))

        if !cellViewModels.contains(viewModel) {
          cellViewModels.append(viewModel)
        }
      }
    }
  }
  
  private var apiInfo: RMGetAllEpisodesResponse.Info?
  
  private var cellViewModels: [RMCharacterEpisodeCellViewModel] = []
  
  public var shouldShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }
  
  private var isLoadingMoreEpisode = false
  
  /// Fetch initials set of episodes (20)
  public func fetchEpisode() {
    RMService.shared.execute(
      .listEpisodesRequests,
      expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
      switch result {
        case .success(let responseModel):
          let results = responseModel.results
          self?.apiInfo = responseModel.info
          self?.episodes = results
          DispatchQueue.main.async {
            self?.delegate?.didLoadInitialEpisode()
          }
        case .failure(let failure):
          print(String(describing: failure))
      }
    }
  }
  
  /// Paginate if additional episodes are needed
  public func fetchAdditionalEpisodes(url: URL) {
    guard !isLoadingMoreEpisode else {
      return
    }
    
    isLoadingMoreEpisode = true
    guard let rmRequest = RMRequest(url: url) else {
      isLoadingMoreEpisode = false
      return
    }
    
    RMService.shared.execute(
      rmRequest,
      expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
      switch result {
        case .success(let responseModel):
          let moreResults = responseModel.results
          self?.apiInfo = responseModel.info
          
          let originalCount = self?.episodes.count ?? 0
          let newCount = moreResults.count
          let total = originalCount + newCount
          let startingIndex = total - newCount
          let indexPathsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
          }
          
          self?.episodes.append(contentsOf: moreResults)
          DispatchQueue.main.async {
            self?.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
            self?.isLoadingMoreEpisode = false
          }
        case .failure(let failure):
          print(failure)
          self?.isLoadingMoreEpisode = false
      }
    }
  }
}

// MARK: Collection view
extension RMEpisodeListViewViewModel:
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.cellViewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
      for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
      fatalError("Unsupported cell")
    }
    
    cell.configure(with: cellViewModels[indexPath.row])
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = UIScreen.main.bounds
    let width: CGFloat = (bounds.width - 30) / 2
    return CGSize(width: width, height: width * 0.8)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter else {
      fatalError("Unsupported reusable view")
    }
    
    guard let footer = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
      for: indexPath
    ) as? RMFooterLoadingCollectionReusableView else {
      fatalError("Unsupported reusable view")
    }
    
    footer.startAnimating()
            
    return footer
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard shouldShowLoadMoreIndicator else {
      return .zero
    }
    
    return CGSize(width: collectionView.frame.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let character = episodes[indexPath.row]
    delegate?.didSelectEpisode(character)
  }
}

// MARK: Scroll view
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard shouldShowLoadMoreIndicator,
      !isLoadingMoreEpisode,
      !cellViewModels.isEmpty,
      let nextUrlString = apiInfo?.next,
      let url = URL(string: nextUrlString) else {
      return
    }
    
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewHeight = scrollView.frame.size.height
      
      if offset >= (totalContentHeight - totalScrollViewHeight - 120) {
        self?.fetchAdditionalEpisodes(url: url)
      }
      
      timer.invalidate()
    }
  }
}
