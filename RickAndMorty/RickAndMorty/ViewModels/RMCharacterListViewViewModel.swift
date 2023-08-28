//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/08/23.
//

import UIKit

protocol RMCharacterListViewModelDelegate: AnyObject {
  func didLoadInitialCharacters()
}

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
  
  private var cellViewModel: [RMCharacterCollectionViewCellViewModel] = []
  /// Requesting the list of characters
  public func fetchCharacters() {
    RMService.shared.execute(
      .listCharactersRequests,
      expecting: RMGetAllCharactersResponse.self) { [weak self] result in
      switch result {
        case .success(let responseModel):
          let results = responseModel.results
          self?.characters = results
          DispatchQueue.main.async {
            self?.delegate?.didLoadInitialCharacters()
          }
        case .failure(let failure):
          print(String(describing: failure))
      }
    }
  }
}

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
}
