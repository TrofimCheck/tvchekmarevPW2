//
//  AddWishCell.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 10.11.2025.
//

import UIKit

final class AddWishCell: UITableViewCell {
    static let reuseId = "AddWishCell"
    
    var addWish: ((String) -> Void)?

    // MARK: - Constants
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let textFontSize: CGFloat = 16
        static let textInset: CGFloat = 10
        static let textMinHeight: CGFloat = 80
        static let textCornerRadius: CGFloat = 10
        static let textBorderWidth: CGFloat = 1
        static let textBorderColor: CGColor = UIColor.systemGray4.cgColor
        static let textContentInset: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        static let buttonTop: CGFloat = 8
        static let buttonHeight: CGFloat = 44
        static let buttonCornerRadius: CGFloat = 10
        static let buttonFontSize: CGFloat = 17
        static let buttonAddTitle: String = "Add wish"
        static let buttonSaveDefaultTitle: String = "Save"
        static let buttonBackground: UIColor = .systemPink
        static let buttonTitleColor: UIColor = .white
    }

    // MARK: - UI
    private let wrap = UIView()
    private let textView = UITextView()
    private let addButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UI Configuration
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(wrap)
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinVertical(to: contentView, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: contentView, Constants.wrapOffsetH)

        wrap.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: Constants.textFontSize)
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = Constants.textCornerRadius
        textView.layer.borderWidth = Constants.textBorderWidth
        textView.layer.borderColor = Constants.textBorderColor
        textView.textContainerInset = Constants.textContentInset

        wrap.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle(Constants.buttonAddTitle, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .semibold)
        addButton.backgroundColor = Constants.buttonBackground
        addButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        addButton.layer.cornerRadius = Constants.buttonCornerRadius
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.textInset),
            textView.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.textInset),
            textView.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.textInset),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.textMinHeight),

            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.buttonTop),
            addButton.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.textInset),
            addButton.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.textInset),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addButton.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.textInset)
        ])
    }
    
    // MARK: - Configuration
    func configureForEdit(text: String, buttonTitle: String = Constants.buttonSaveDefaultTitle) {
        textView.text = text
        addButton.setTitle(buttonTitle, for: .normal)
    }

    // MARK: - Actions
    @objc private func addButtonTapped() {
        let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { return }
        addWish?(text)
        textView.text = ""
        textView.resignFirstResponder()
    }
}
