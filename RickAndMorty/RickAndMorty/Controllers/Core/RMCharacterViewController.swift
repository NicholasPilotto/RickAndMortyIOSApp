//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Characters"
    view.backgroundColor = .systemBackground
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
