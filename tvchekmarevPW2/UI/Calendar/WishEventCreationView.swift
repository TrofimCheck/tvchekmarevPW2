//
//  WishEventCreationView.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 16.01.2026.
//

import UIKit

final class WishEventCreationView: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let title: String = "New Event"
        static let contentSide: Double = 16
        static let contentTop: Double = 16
        static let contentBottom: Double = 16
        static let stackSpacing: Double = 12
        static let textFieldHeight: Double = 44
        static let textViewHeight: Double = 100
        static let startTitle: String = "Start"
        static let endTitle: String = "End"
        static let titlePlaceholder: String = "Event title"
        static let descriptionPlaceholder: String = "Description"
        static let cancelTitle: String = "Cancel"
        static let createTitle: String = "Create"
        static let dateFormat: String = "MMM d, HH:mm"
        static let wishesKey: String = "savedWishes"
        static let pickWishTitle: String = "Pick from saved wishes"
        static let emptyWishesTitle: String = "No saved wishes"
        static let emptyWishesMessage: String = "Add wishes first, then you can pick one here."
        static let okTitle: String = "OK"
        static let pickSheetTitle: String = "Saved wishes"
        static let pickSheetCancel: String = "Cancel"
        static let pickWishButtonHeight: Double = 44
    }

    // MARK: - Data
    private let defaults = UserDefaults.standard
    private var savedWishes: [String] = []

    // MARK: - Output
    var onCreate: ((WishEventModel) -> Void)?
    
    // MARK: - Dependencies
    private let calendarManager: CalendarManaging = CalendarManager()

    // MARK: - UI
    private let contentStack = UIStackView()
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startLabel = UILabel()
    private let startPicker = UIDatePicker()
    private let endLabel = UILabel()
    private let endPicker = UIDatePicker()
    private let pickWishButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = Constants.title
        configureNavBar()
        configureUI()
        loadSavedWishes()
    }

    // MARK: - Nav Bar
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.cancelTitle,
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.createTitle,
            style: .done,
            target: self,
            action: #selector(createTapped)
        )
    }

    // MARK: - UI Configuration
    private func configureUI() {
        contentStack.axis = .vertical
        contentStack.spacing = Constants.stackSpacing

        view.addSubview(contentStack)
        contentStack.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.contentTop)
        contentStack.pinLeft(to: view, Constants.contentSide)
        contentStack.pinRight(to: view, Constants.contentSide)
        contentStack.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.contentBottom)

        configureTitleField()
        configureDescriptionField()
        configureDatePickers()

        [titleField,
         pickWishButton,
         descriptionField,
         startLabel, startPicker,
         endLabel, endPicker].forEach { contentStack.addArrangedSubview($0) }
        configurePickWishButton()
    }

    private func configureTitleField() {
        titleField.placeholder = Constants.titlePlaceholder
        titleField.borderStyle = .roundedRect
        titleField.setHeight(Constants.textFieldHeight)
    }

    private func configureDescriptionField() {
        descriptionField.placeholder = Constants.descriptionPlaceholder
        descriptionField.borderStyle = .roundedRect
        descriptionField.setHeight(Constants.textFieldHeight)
    }

    private func configureDatePickers() {
        startLabel.text = Constants.startTitle
        endLabel.text = Constants.endTitle

        [startLabel, endLabel].forEach {
            $0.font = .boldSystemFont(ofSize: 16)
        }

        [startPicker, endPicker].forEach {
            $0.datePickerMode = .dateAndTime
            $0.preferredDatePickerStyle = .wheels
        }
        
        endPicker.date = Calendar.current.date(byAdding: .hour, value: 1, to: startPicker.date) ?? startPicker.date
    }
    
    private func configurePickWishButton() {
        pickWishButton.setTitle(Constants.pickWishTitle, for: .normal)
        pickWishButton.setHeight(Constants.pickWishButtonHeight)
        pickWishButton.layer.cornerRadius = 10
        pickWishButton.layer.borderWidth = 1
        pickWishButton.layer.borderColor = UIColor.systemGray4.cgColor
        pickWishButton.addTarget(self, action: #selector(pickWishTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc
    private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc
    private func createTapped() {
        let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !title.isEmpty else { return }

        let notes = descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let start = startPicker.date
        var end = endPicker.date
        if end < start { end = start }

        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat

        let uiModel = WishEventModel(
            title: title,
            description: notes,
            startDate: formatter.string(from: start),
            endDate: formatter.string(from: end)
        )

        let calendarModel = CalendarEventModel(
            title: title,
            startDate: start,
            endDate: end,
            note: notes.isEmpty ? nil : notes
        )

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let created = self.calendarManager.create(eventModel: calendarModel)

            DispatchQueue.main.async {
                guard created else {
                    self.showCalendarError()
                    return
                }
                self.onCreate?(uiModel)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc
    private func pickWishTapped() {
        loadSavedWishes()
        view.endEditing(true)

        guard !savedWishes.isEmpty else {
            let alert = UIAlertController(
                title: Constants.emptyWishesTitle,
                message: Constants.emptyWishesMessage,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default))
            present(alert, animated: true)
            return
        }

        let sheet = UIAlertController(title: Constants.pickSheetTitle, message: nil, preferredStyle: .actionSheet)

        savedWishes.forEach { wish in
            sheet.addAction(UIAlertAction(title: wish, style: .default) { [weak self] _ in
                self?.titleField.text = wish
            })
        }

        sheet.addAction(UIAlertAction(title: Constants.pickSheetCancel, style: .cancel))
        present(sheet, animated: true)
    }

    // MARK: - Helpers
    private func showCalendarError() {
        let alert = UIAlertController(
            title: "Couldn't create event",
            message: "Please allow Calendar access in Settings and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func loadSavedWishes() {
        savedWishes = defaults.array(forKey: Constants.wishesKey) as? [String] ?? []
    }
}
