//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import SafariServices
import StoreKit
import SwiftUI
import UIKit

/// Controller to show variuous app options and settings
final class RMSettingsViewController: UIViewController {
  private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Settings"
    view.backgroundColor = .systemBackground
    
    addSwiftUIControllers()
  }
  
  private func addSwiftUIControllers() {
    let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(
      viewModel: RMSettingsViewViewModel(
        cellViewModels: RMSettingsOption.allCases.compactMap {
          return RMSettingCellViewViewModel(type: $0) { [weak self] option in
            self?.handleTap(option: option)
          }
        })
      )
    )
    
    addChild(settingsSwiftUIController)
    settingsSwiftUIController.didMove(toParent: self)
    
    view.addSubviews(settingsSwiftUIController.view)
    
    settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      settingsSwiftUIController.view.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor
      ),
      settingsSwiftUIController.view.leftAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leftAnchor
      ),
      settingsSwiftUIController.view.rightAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.rightAnchor
      ),
      settingsSwiftUIController.view.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      )
    ])
    
    self.settingsSwiftUIController = settingsSwiftUIController
  }
  
  private func handleTap(option: RMSettingsOption) {
    guard Thread.current.isMainThread else {
      return
    }
    
    if let url = option.targetUrl {
      let viewController = SFSafariViewController(url: url)
      present(viewController, animated: true)
    } else if option == .rateApp {
      Task { @MainActor [weak self] in
        if let windowScene = self?.view.window?.windowScene {
          SKStoreReviewController.requestReview(in: windowScene)
        }
      }
    }
  }
}
