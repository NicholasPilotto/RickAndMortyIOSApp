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
}

/// View model to manage character list business logic
final class RMCharacterListViewViewModel: NSObject {
  public weak var delegate: RMCharacterListViewModelDelegate?
  
  private var characters: [RMCharacter] = [] {
    didSet {
      characters.forEach {
        let viewModel = RMCharacterCollectionViewCellViewModel(
          characterName: $0.name,
          characterStauts: $0.status,
          characterImageUrl: URL(string: $0.image))
          cellViewModel.append(viewModel)
      }
    }
  }
  
  private var apiInfo: RMGetAllCharactersResponse.Info?
  
  private var cellViewModel: [RMCharacterCollectionViewCellViewModel] = []
  
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
  public func fetchAdditionalCharacters() {
    isLoadingMoreCharacter = true
  }
}

// MARK: Collection view
extension RMCharacterListViewViewModel:
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.cellViewModel.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
      for: indexPath) as? RMCharacterCollectionViewCell else {
      fatalError("Unsupported cell")
    }
    
    cell.configure(with: cellViewModel[indexPath.row])
    
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
    guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacter else {
      return
    }
    
    let offset = scrollView.contentOffset.y
    let totalContentHeight = scrollView.contentSize.height
    let totalScrollViewHeight = scrollView.frame.size.height
    
    if offset >= (totalContentHeight - totalScrollViewHeight - 120) {
      fetchAdditionalCharacters()
    }
  }
}
