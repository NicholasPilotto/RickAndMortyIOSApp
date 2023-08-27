//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/08/23.
//

import UIKit

class CharacterListViewViewModel: NSObject {
  /// Requesting the list of characters
  public func fetchCharacters() {
    RMService.shared.execute(RMRequest.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { result in
      switch result {
        case .success(let model):
          print(String(describing: model))
        case .failure(let failure):
          print(String(describing: failure))
      }
    }
  }
}

extension CharacterListViewViewModel:
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .systemRed
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = UIScreen.main.bounds
    let width: CGFloat = (bounds.width - 30) / 2
    return CGSize(width: width, height: width * 1.5)
  }
}
