//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController {
  private let characterListView = CharacterListView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Characters"
    view.backgroundColor = .systemBackground
    setUpView()
  }
  
  private func setUpView() {
    view.addSubview(characterListView)
    
    NSLayoutConstraint.activate([
      characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
