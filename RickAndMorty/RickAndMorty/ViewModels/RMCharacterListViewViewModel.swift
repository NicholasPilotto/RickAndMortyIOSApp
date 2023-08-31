//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/08/23.
//

import UIKit

protocol RMCharacterListViewModelDelegate: AnyObject {
  func didLoadInitialCharacters()
  func didSelectCharacter(_ character: RMCharacter)
  func didLoadMoreCharacter(with newIndexPath: [IndexPath])
}

/// View model to manage character list business logic
final class RMCharacterListViewViewModel: NSObject {
  public weak var delegate: RMCharacterListViewModelDelegate?
  
  private var characters: [RMCharacter] = [] {
    didSet {
      for character in characters {
        let viewModel = RMCharacterCollectionViewCellViewModel(
          characterName: character.name,
          characterStauts: character.status,
          characterImageUrl: URL(string: character.image))
  
        if cellViewModels.contains(viewModel) {
          cellViewModels.append(viewModel)
        }
      }
    }
  }
  
  private var apiInfo: RMGetAllCharactersResponse.Info?
  
  private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
  
  public var shouldShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }
  
  private var isLoadingMoreCharacter = false
  
  /// Fetch initials set of characters (20)
  public func fetchCharacters() {
    RMService.shared.execute(
      .listCharactersRequests,
      expecting: RMGetAllCharactersResponse.self) { [weak self] result in
      switch result {
        case .success(let responseModel):
          let results = responseModel.results
          self?.apiInfo = responseModel.info
          self?.characters = results
          DispatchQueue.main.async {
            self?.delegate?.didLoadInitialCharacters()
          }
        case .failure(let failure):
          print(String(describing: failure))
      }
    }
  }
  
  /// Paginate if additional characters are needed
  public func fetchAdditionalCharacters(url: URL) {
    guard !isLoadingMoreCharacter else {
      return
    }
    
    isLoadingMoreCharacter = true
    guard let rmRequest = RMRequest(url: url) else {
      isLoadingMoreCharacter = false
      return
    }
    
    RMService.shared.execute(
      rmRequest,
      expecting: RMGetAllCharactersResponse.self) { [weak self] result in
      switch result {
        case .success(let responseModel):
          let moreResults = responseModel.results
          self?.apiInfo = responseModel.info
          
          let originalCount = self?.characters.count ?? 0
          let newCount = moreResults.count
          let total = originalCount + newCount
          let startingIndex = total - newCount
          let indexPathsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
          }
          
          self?.characters.append(contentsOf: moreResults)
          DispatchQueue.main.async {
            self?.delegate?.didLoadMoreCharacter(with: indexPathsToAdd)
            self?.isLoadingMoreCharacter = false
          }
        case .failure(let failure):
          print(failure)
          self?.isLoadingMoreCharacter = false
      }
    }
  }
}

// MARK: Collection view
extension RMCharacterListViewViewModel:
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.cellViewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
      for: indexPath) as? RMCharacterCollectionViewCell else {
      fatalError("Unsupported cell")
    }
    
    cell.configure(with: cellViewModels[indexPath.row])
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = UIScreen.main.bounds
    let width: CGFloat = (bounds.width - 30) / 2
    return CGSize(width: width, height: width * 1.5)
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
    let character = characters[indexPath.row]
    delegate?.didSelectCharacter(character)
  }
}

// MARK: Scroll view
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard shouldShowLoadMoreIndicator,
      !isLoadingMoreCharacter,
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
        self?.fetchAdditionalCharacters(url: url)
      }
      
      timer.invalidate()
    }
  }
}
