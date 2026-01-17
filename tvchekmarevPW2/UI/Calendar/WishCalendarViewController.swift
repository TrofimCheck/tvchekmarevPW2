//
//  WishCalendarViewController.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 15.01.2026.
//

import UIKit

final class WishCalendarViewController: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let title: String = "Wish Calendar"
        static let backgroundColor: UIColor = .systemPink
        static let collectionBackgroundColor: UIColor = .clear
        static let collectionTop: Double = 20
        static let contentInset: UIEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        static let cellHeight: CGFloat = 160
        static let cellHorizontalInsetTotal: CGFloat = 10
        static let lineSpacing: CGFloat = 0
    }

    // MARK: - UI
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Data
    private let storage = WishEventStorage.shared
    private var events: [WishEventModel] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadEvents()
        configureAddButton()
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        title = Constants.title
        configureCollection()
    }

    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Constants.collectionBackgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset

        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = Constants.lineSpacing
        }

        view.addSubview(collectionView)

        collectionView.pinHorizontal(to: view)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.collectionTop)
    }

    // MARK: - Add Button
    private func configureAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEventTapped)
        )
    }

    // MARK: - Data
    private func loadEvents() {
        events = storage.fetchEvents()
        collectionView.reloadData()
    }

    // MARK: - Actions
    @objc
    private func addEventTapped() {
        let vc = WishEventCreationView()
        vc.onCreate = { [weak self] newEvent in
            guard let self else { return }
            self.storage.addEvent(newEvent)
            self.loadEvents()
        }

        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WishEventCell.reuseIdentifier,
            for: indexPath
        )

        guard let wishEventCell = cell as? WishEventCell else { return cell }
        wishEventCell.configure(with: events[indexPath.item])
        return wishEventCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.bounds.width - Constants.cellHorizontalInsetTotal,
            height: Constants.cellHeight
        )
    }
}
