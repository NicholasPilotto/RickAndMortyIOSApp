//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 03/09/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
  private let viewModel: RMEpisodeDetailViewViewModel
  
  private let episodeDetailView = RMEpisodeDetailView()
  
  init(url: URL?) {
    self.viewModel = .init(endpointUrl: url)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Episode"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .action, target: self, action: #selector(didTapShare)
    )
    
    view.addSubviews(episodeDetailView)
    
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
}
