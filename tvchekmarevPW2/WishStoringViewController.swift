//
//  WishStoringViewController.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 08.11.2025.
//

import UIKit

final class WishStoringViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 40
        static let viewBackgroundColor: UIColor = .blue
        static let tableBackgroundColor: UIColor = .red
        static let numberOfSections: Int = 2
        static let addSectionIndex: Int = 0
        static let listSectionIndex: Int = 1
        static let wishesKey: String = "savedWishes"
        static let deleteActionTitle: String = "Delete"
        static let saveButtonTitle: String = "Save"
    }
    
    // MARK: - UI
    private let table = UITableView(frame: .zero)
    
    // MARK: - Data
    private let defaults = UserDefaults.standard
    private var wishArray: [String] = []
    private var editingIndexPath: IndexPath?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        loadWishes()
        configureTable()
    }
    
    // MARK: - UI Configuration
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = Constants.tableBackgroundColor
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.pin(to: view, Constants.tableOffset)
        
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }
    
    // MARK: - Data Persistence
    private func saveWishes() {
        defaults.set(wishArray, forKey: Constants.wishesKey)
    }
    
    private func loadWishes() {
        if let saved = defaults.array(forKey: Constants.wishesKey) as? [String] {
            wishArray = saved
        } else {
            wishArray = []
        }
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.addSectionIndex:
            return 1
        case Constants.listSectionIndex:
            return wishArray.count
        default:
            return 0
        }
    }
    
    // MARK: - Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Constants.addSectionIndex:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath)
            guard let addCell = cell as? AddWishCell else { return cell }
            addCell.addWish = { [weak self] text in
                guard let self = self else { return }
                self.wishArray.insert(text, at: 0)
                self.saveWishes()
                self.table.reloadData()
            }
            return addCell

        case Constants.listSectionIndex:
            if editingIndexPath == indexPath {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath)
                guard let editCell = cell as? AddWishCell else { return cell }

                editCell.configureForEdit(text: wishArray[indexPath.row], buttonTitle: Constants.saveButtonTitle)
                editCell.addWish = { [weak self] newText in
                    guard let self = self else { return }
                    self.wishArray[indexPath.row] = newText
                    self.saveWishes()
                    self.editingIndexPath = nil
                    self.table.reloadRows(at: [indexPath], with: .automatic)
                }
                return editCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
                guard let wishCell = cell as? WrittenWishCell else { return cell }
                wishCell.configure(with: wishArray[indexPath.row])
                return wishCell
            }

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    // MARK: - Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        guard indexPath.section == Constants.listSectionIndex else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: Constants.deleteActionTitle) { [weak self] _, _, done in
            guard let self = self else { return }
            self.wishArray.remove(at: indexPath.row)
            self.saveWishes()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Selection / Inline Editing
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Constants.listSectionIndex else { return }
        tableView.deselectRow(at: indexPath, animated: true)

        if let prev = editingIndexPath, prev != indexPath {
            editingIndexPath = nil
            tableView.reloadRows(at: [prev], with: .automatic)
        }

        editingIndexPath = indexPath
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
