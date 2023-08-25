//
//  RMTabBarViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 24/08/23.
//

import UIKit

final class RMTabBarViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
  }
  
  private func setupTabs() {
    let characterVC = RMCharacterViewController()
    let locationVC = RMLocationViewController()
    let episodeVC = RMEpisodeViewController()
    let settingsVC = RMSettingsViewController()
    
    let navigationTab1 = UINavigationController(rootViewController: characterVC)
    let navigationTab2 = UINavigationController(rootViewController: locationVC)
    let navigationTab3 = UINavigationController(rootViewController: episodeVC)
    let navigationTab4 = UINavigationController(rootViewController: settingsVC)
    
    [navigationTab1, navigationTab2, navigationTab3, navigationTab4]
      .forEach {
        $0.navigationBar.prefersLargeTitles = true
        $0.navigationItem.largeTitleDisplayMode = .automatic
      }
    
    navigationTab1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
    navigationTab2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
    navigationTab3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
    navigationTab4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
    
    setViewControllers([navigationTab1, navigationTab2, navigationTab3, navigationTab4], animated: true)
  }
}
