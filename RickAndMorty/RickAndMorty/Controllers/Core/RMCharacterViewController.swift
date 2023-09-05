//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {
  private let characterListView = RMCharacterListView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Characters"
    view.backgroundColor = .systemBackground
    setUpView()
    addSearchButton()
  }
  
  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)
    )
  }
  
  @objc private func didTapSearch() {
    let searchVC = RMSearchViewController(config: .init(type: .character))
    searchVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(searchVC, animated: true)
  }
  
  private func setUpView() {
    characterListView.delegate = self
    view.addSubview(characterListView)
    
    NSLayoutConstraint.activate([
      characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  // MARK: RMCharacterListViewDelegate

  func rmCharacterListView(_ characterView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
    // open detail controller for that character
    let viewModel = RMCharacterDetailViewViewModel(character: character)
    let detailViewController = RMCharacterDetailViewController(viewModel: viewModel)
    detailViewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
