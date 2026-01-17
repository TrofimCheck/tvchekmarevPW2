//
//  WishEventCell.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 16.01.2026.
//

import UIKit

final class WishEventCell: UICollectionViewCell {

    // MARK: - Constants
    private enum Constants {
        static let cardInset: Double = 10
        static let cardCornerRadius: CGFloat = 16
        static let titleTop: Double = 14
        static let side: Double = 14
        static let titleFont: UIFont = .boldSystemFont(ofSize: 22)
        static let descriptionFont: UIFont = .systemFont(ofSize: 16)
        static let dateFont: UIFont = .systemFont(ofSize: 14)
        static let descriptionTop: Double = 6
        static let dateTop: Double = 10
        static let endTop: Double = 4
        static let bottom: Double = 14
        static let datePrefix: String = "Start: "
        static let endPrefix: String = "End: "
        static let titleLines: Int = 1
        static let descriptionLines: Int = 2
    }

    // MARK: - Reuse
    static let reuseIdentifier = "WishEventCell"

    // MARK: - UI
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startLabel = UILabel()
    private let endLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        startLabel.text = nil
        endLabel.text = nil
        descriptionLabel.isHidden = false
    }

    // MARK: - Configuration
    func configure(with event: WishEventModel) {
        titleLabel.text = event.title

        let desc = event.description.trimmingCharacters(in: .whitespacesAndNewlines)
        descriptionLabel.text = desc
        descriptionLabel.isHidden = desc.isEmpty

        startLabel.text = Constants.datePrefix + event.startDate
        endLabel.text = Constants.endPrefix + event.endDate
    }

    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.pin(to: contentView, Constants.cardInset)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = Constants.cardCornerRadius
        cardView.clipsToBounds = true

        configureTitle()
        configureDescription()
        configureDates()
    }

    // MARK: - Title
    private func configureTitle() {
        cardView.addSubview(titleLabel)
        titleLabel.font = Constants.titleFont
        titleLabel.numberOfLines = Constants.titleLines

        titleLabel.pinTop(to: cardView, Constants.titleTop)
        titleLabel.pinLeft(to: cardView, Constants.side)
        titleLabel.pinRight(to: cardView, Constants.side)
    }

    // MARK: - Description
    private func configureDescription() {
        cardView.addSubview(descriptionLabel)
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = Constants.descriptionLines

        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.pinLeft(to: cardView, Constants.side)
        descriptionLabel.pinRight(to: cardView, Constants.side)
    }

    // MARK: - Dates
    private func configureDates() {
        [startLabel, endLabel].forEach {
            $0.font = Constants.dateFont
            $0.textColor = .gray
            $0.numberOfLines = 1
        }

        cardView.addSubview(startLabel)
        startLabel.pinTop(to: descriptionLabel.bottomAnchor, Constants.dateTop)
        startLabel.pinLeft(to: cardView, Constants.side)
        startLabel.pinRight(to: cardView, Constants.side)

        cardView.addSubview(endLabel)
        endLabel.pinTop(to: startLabel.bottomAnchor, Constants.endTop)
        endLabel.pinLeft(to: cardView, Constants.side)
        endLabel.pinRight(to: cardView, Constants.side)
        endLabel.pinBottom(to: cardView, Constants.bottom)
    }
}
