//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 25/08/23.
//

import UIKit

/// Controller to show variuous app options and settings
final class RMSettingsViewController: UIViewController {
  private let viewModel = RMSettingsViewViewModel(cellViewModels:
    RMSettingsOption.allCases.compactMap {
      return RMSettingCellViewViewModel(type: $0)
    }
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Settings"
    view.backgroundColor = .systemBackground
  }
}
