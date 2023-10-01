//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 23/09/23.
//

import UIKit

class RMSearchOptionPickerViewController: UIViewController {
  private let option: RMSearchInputViewViewModel.DynamicOptions
  private let selectionBlock: (String) -> Void

  private let tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()

  init(option: RMSearchInputViewViewModel.DynamicOptions, selection: @escaping (String) -> Void) {
    self.option = option
    self.selectionBlock = selection
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    view.addSubview(tableView)

    tableView.delegate = self
    tableView.dataSource = self

    addConstraints()
  }

  // MARK: - Private methods

  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

// MARK: - UITableView delegate and datasource methods

extension RMSearchOptionPickerViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return option.choises.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let choise = option.choises[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
    cell.textLabel?.text = choise.capitalized
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.selectionBlock(option.choises[indexPath.row])
    dismiss(animated: true)
  }
}
