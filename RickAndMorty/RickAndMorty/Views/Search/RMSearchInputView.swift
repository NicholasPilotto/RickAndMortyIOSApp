//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
  func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
  func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String)
  func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

/// View for top part of search screen with search bar
final class RMSearchInputView: UIView {
  private let searchBar: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "Search"
    bar.translatesAutoresizingMaskIntoConstraints = false
    return bar
  }()
  
  private var viewModel: RMSearchInputViewViewModel? {
    didSet {
      guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
        return
      }
      
      let options = viewModel.options
      createOptionsSelectionView(options: options)
    }
  }
  
  private var stackView: UIStackView?
  
  weak public var delegate: RMSearchInputViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubviews(searchBar)
    
    addConstraints()
    
    searchBar.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private methods
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 3),
      searchBar.leftAnchor.constraint(equalTo: leftAnchor),
      searchBar.rightAnchor.constraint(equalTo: rightAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 55)
    ])
  }
  
  private func createOptionsSelectionView(options: [RMSearchInputViewViewModel.DynamicOptions]) {
    let stackView = createOptionStackView()
    
    for i in 0..<options.count {
      let option = options[i]
      let button = createButton(with: option, tag: i)
      
      stackView.addArrangedSubview(button)
    }
  }
  
  @objc private func didTapButton(_ sender: UIButton) {
    guard let options = viewModel?.options else {
      return
    }
    
    let tag = sender.tag
    let selected = options[tag]
    
    delegate?.rmSearchInputView(self, didSelectOption: selected)
  }
  
  private func createOptionStackView() -> UIStackView {
    let stackView = UIStackView()
    self.stackView = stackView
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 6
    
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    return stackView
  }
  
  private func createButton(with option: RMSearchInputViewViewModel.DynamicOptions, tag: Int) -> UIButton {
    let button = UIButton()
    button.backgroundColor = .secondarySystemFill
    button.setAttributedTitle(
      NSAttributedString(string: option.rawValue, attributes: [
        .font: UIFont.systemFont(ofSize: 18, weight: .medium),
        .foregroundColor: UIColor.label
      ]),
      for: .normal
    )
    
    button.tag = tag
    button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    button.layer.cornerRadius = 8
    button.layer.cornerCurve = CALayerCornerCurve.continuous
    
    return button
  }
  
  // MARK: - Public methods
  
  /// Configure view with view model
  /// - Parameter viewModel: view model that manages view
  public func configure(with viewModel: RMSearchInputViewViewModel) {
    searchBar.placeholder = viewModel.searchPlaceholderText
    self.viewModel = viewModel
  }
  
  /// Show keyboard
  public func presentKeyboard() {
    searchBar.becomeFirstResponder()
  }
  
  /// Update option button title text and tint color
  /// - Parameters:
  ///   - option: Search dynamic option
  ///   - value: New value for the button title
  public func update(option: RMSearchInputViewViewModel.DynamicOptions, value: String) {
    guard let buttons = stackView?.arrangedSubviews as? [UIButton],
    let allOptions = viewModel?.options,
    let index = allOptions.firstIndex(of: option) else {
      return
    }
    
    let button = buttons[index]
    button.setAttributedTitle(
      NSAttributedString(string: value.capitalized, attributes: [
        .font: UIFont.systemFont(ofSize: 18, weight: .medium),
        .foregroundColor: UIColor.link
      ]),
      for: .normal
    )
  }
}

extension RMSearchInputView: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Notify delegate of change text
    delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    //  Notify that search button was tapped
    delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
  }
}
