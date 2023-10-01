//
//  RMCharacterEpisodeCellViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

protocol RMEpisodeDataRender {
  var episode: String { get }
  var air_date: String { get }
  var name: String { get }
}

final class RMCharacterEpisodeCellViewModel: Hashable, Equatable {
  private let episodeDataUrl: URL?
  private var isFetching = false
  private var dataBlock: ((RMEpisodeDataRender) -> Void)?

  private var episode: RMEpisode? {
    didSet {
      guard let model = episode else {
        return
      }

      self.dataBlock?(model)
    }
  }

  public let borderColor: UIColor

  init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
    self.episodeDataUrl = episodeDataUrl
    self.borderColor = borderColor
  }

  /// Publisher-Subscriber block called when episode is fetched
  /// - Parameter block: Block execute when episode is fetched
  public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
    self.dataBlock = block
  }

  /// Fetch episode data
  public func fetchEpisode() {
    guard !isFetching else {
      if let model = episode {
        self.dataBlock?(model)
      }
      return
    }

    guard let url = episodeDataUrl, let rmRequest = RMRequest(url: url) else {
      return
    }

    isFetching = true

    RMService.shared.execute(rmRequest, expecting: RMEpisode.self) { [weak self] result in
      switch result {
        case .success(let model):
          DispatchQueue.main.async {
            self?.episode = model
          }
        case .failure(let failure):
          print(failure)
      }
    }
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
  }

  static func == (lhs: RMCharacterEpisodeCellViewModel, rhs: RMCharacterEpisodeCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
