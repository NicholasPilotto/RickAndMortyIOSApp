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
    
    let request = RMRequest(
      endpoint: .character,
      pathComponents: ["1"],
      queryParameters: [
        URLQueryItem(name: "name", value: "rick"),
        URLQueryItem(name: "status", value: "alive")
      ])
    
    print(request.url ?? "error")
    
    RMService.shared.execute(request, expecting: RMCharacter.self) { result in
      switch result {
        case .success(let character):
          print(character.id)
        case .failure(let error):
          print(error)
      }
    }
  }
}
