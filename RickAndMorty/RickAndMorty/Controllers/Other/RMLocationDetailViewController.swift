//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 16/09/23.
//

import UIKit

class RMLocationDetailViewController: UIViewController, RMLocationDetailViewViewModelDelegate {
  private let viewModel: RMLocationDetailViewViewModel

  private let episodeDetailView = RMLocationDetailView()

  init(location: RMLocation) {
    let url = URL(string: location.url)
    self.viewModel = .init(endpointUrl: url)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Location"

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action, target: self, action: #selector(didTapShare)
    )

    view.addSubviews(episodeDetailView)

    episodeDetailView.delegate = self

    viewModel.delegate = self
    viewModel.fetchLocationData()

    addConstraints()
  }

  private func addConstraints() {
    NSLayoutConstraint.activate([
      episodeDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      episodeDetailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      episodeDetailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      episodeDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  @objc private func didTapShare() {
  }

  // MARK: RMEpisodeListViewModelDelegate implementation

  func didFetchLocationDetails() {
    episodeDetailView.configure(with: viewModel)
  }
}

// MARK: RMEpisodeDetailViewDelegate methods implementation

extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
  func rmEpisodeDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
    let viewController = RMCharacterDetailViewController(viewModel: .init(character: character))
    viewController.title = character.name
    viewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(viewController, animated: true)
  }
}
