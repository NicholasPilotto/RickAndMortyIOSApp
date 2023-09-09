//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import SwiftUI
import UIKit

/// Controller to show variuous app options and settings
final class RMSettingsViewController: UIViewController {
  private let viewModel = RMSettingsViewViewModel(cellViewModels:
    RMSettingsOption.allCases.compactMap {
      return RMSettingCellViewViewModel(type: $0)
    }
  )
  
  private let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(
    viewModel: RMSettingsViewViewModel(
      cellViewModels: RMSettingsOption.allCases.compactMap {
        return RMSettingCellViewViewModel(type: $0)
      })
    )
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Settings"
    view.backgroundColor = .systemBackground
    
    addSwiftUIControllers()
  }
  
  private func addSwiftUIControllers() {
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
  }
}
