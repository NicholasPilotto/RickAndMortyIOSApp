//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show and search for episodes
final class RMEpisodeViewController: UIViewController, RMEpisodeListViewDelegate {
  private let episodeListView = RMEpisodeListView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Characters"
    view.backgroundColor = .systemBackground
    setUpView()
    
    addSearchButton()
  }
  
  private func setUpView() {
    episodeListView.delegate = self
    view.addSubview(episodeListView)
    
    NSLayoutConstraint.activate([
      episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func addSearchButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)
    )
  }
  
  @objc private func didTapSearch() {
    let viewController = RMSearchViewController(config: .init(type: .episode))
    viewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: RMCharacterListViewDelegate

  func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
    // open detail controller for that character
    let detailViewController = RMEpisodeDetailViewController(url: URL(string: episode.url))
    detailViewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
