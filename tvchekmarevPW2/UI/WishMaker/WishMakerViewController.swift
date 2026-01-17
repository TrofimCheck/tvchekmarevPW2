//
//  ViewController.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 23.09.2025.
//

import UIKit

final class WishMakerViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let titleText: String = "Wish Maker"
        static let titleFont: CGFloat = 32
        static let titleTextColor: UInt32 = 0x008000
        static let titleLeading: CGFloat = 20
        static let titleTop: CGFloat = 30
        static let descriprionText: String = "Wish Maker is a playful app where you create your own mood through colors. Move the red, green, and blue sliders to design a unique background and make a wish."
        static let descriptionFont: CGFloat = 18
        static let descriptionTextColor: UInt32 = 0x008000
        static let descriptionLeading: CGFloat = 20
        static let descriptionTop: CGFloat = 20
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        static let slidersStackRadius: CGFloat = 20
        static let slidersStackLeading: CGFloat = 20
        static let backgroundAlpha: CGFloat = 1
        static let actionStackBottom: Double = 30
        static let actionStackSide: Double = 20
        static let actionStackSpacing: Double = 12
        static let actionButtonHeight: Double = 60
        static let actionButtonCornerRadius: CGFloat = 20
        static let actionButtonBackgroundColor: UIColor = .white
        static let actionButtonTitleColor: UIColor = .systemPink
        static let toggleButtonTitle: String = "Toggle Sliders"
        static let addWishButtonTitle: String = "Add more wishes"
        static let scheduleWishesButtonTitle: String = "Schedule wish granting"
        static let spacing: CGFloat = 15
    }
    
    // MARK: - Color State
    private struct Colors {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
    }

    private var colors = Colors(red: 0, green: 0, blue: 0) {
        didSet {
            let current = currentColor
            view.backgroundColor = current

            [toggleButton, addWishButton, scheduleWishesButton].forEach {
                $0.setTitleColor(current, for: .normal)
            }
        }
    }

    private var currentColor: UIColor {
        UIColor(red: colors.red, green: colors.green, blue: colors.blue, alpha: Constants.backgroundAlpha)
    }
    
    // MARK: - UI Elements
    private var titleView: UILabel = UILabel()
    private var descriptionView: UILabel = UILabel()
    private let slidersStack: UIStackView = UIStackView()
    private let addWishButton: UIButton = UIButton(type: .system)
    private let toggleButton: UIButton = UIButton(type: .system)
    private let scheduleWishesButton: UIButton = UIButton(type: .system)
    private let actionStack: UIStackView = UIStackView()
    private let table: UITableView = UITableView(frame: .zero)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = .black
        configureTitle()
        configureDescription()
        configureActionStack()
        configureSliders()
    }
    
    // MARK: - Title
    private func configureTitle() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = Constants.titleText
        titleView.font = UIFont.boldSystemFont(ofSize: Constants.titleFont)
        titleView.textColor = UIColor(hex: Constants.titleTextColor)
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeading),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTop)
        ])
    }
    
    // MARK: - Description
    private func configureDescription() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.text = Constants.descriprionText
        descriptionView.font = UIFont.systemFont(ofSize: Constants.descriptionFont)
        descriptionView.textColor = UIColor(hex: Constants.descriptionTextColor)
        descriptionView.numberOfLines = 0
        view.addSubview(descriptionView)
        NSLayoutConstraint.activate([
            descriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.descriptionLeading),
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Constants.descriptionTop)
        ])
    }
    
    // MARK: - Sliders
    private func configureSliders() {
        slidersStack.translatesAutoresizingMaskIntoConstraints = false
        slidersStack.axis = .vertical
        view.addSubview(slidersStack)
        slidersStack.layer.cornerRadius = Constants.slidersStackRadius
        slidersStack.clipsToBounds = true
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            slidersStack.addArrangedSubview(slider)
        }
        
        slidersStack.pinBottom(to: actionStack.topAnchor, Constants.spacing)
        slidersStack.pinHorizontal(to: view, Constants.slidersStackLeading)
        
        let updateColor: () -> Void = { [weak self] in
            guard let self = self else { return }
            self.colors = Colors(
                red: CGFloat(sliderRed.slider.value),
                green: CGFloat(sliderGreen.slider.value),
                blue: CGFloat(sliderBlue.slider.value)
            )
        }

        sliderRed.valueChanged   = { _ in updateColor() }
        sliderGreen.valueChanged = { _ in updateColor() }
        sliderBlue.valueChanged  = { _ in updateColor() }
    }
    
    // MARK: - Stack of buttons
    private func configureActionStack() {
        actionStack.axis = .vertical
        actionStack.spacing = Constants.actionStackSpacing

        view.addSubview(actionStack)

        actionStack.pinHorizontal(to: view, Constants.actionStackSide)
        actionStack.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.actionStackBottom)

        configureToggleButton()
        configureAddWishButton()
        configureScheduleWishesButton()

        [toggleButton, addWishButton, scheduleWishesButton].forEach {
            $0.setHeight(Constants.actionButtonHeight)
            actionStack.addArrangedSubview($0)
        }
    }
    
    // MARK: - Toggle Button
    private func configureToggleButton() {
        styleActionButton(toggleButton, title: Constants.toggleButtonTitle)
        toggleButton.addTarget(self, action: #selector(toggleSlidersVisibility), for: .touchUpInside)
    }

    // MARK: - Add Wish Button
    private func configureAddWishButton() {
        styleActionButton(addWishButton, title: Constants.addWishButtonTitle)
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Schedule Wish Button
    private func configureScheduleWishesButton() {
        styleActionButton(scheduleWishesButton, title: Constants.scheduleWishesButtonTitle)
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishesButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Buttons Style
    private func styleActionButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = Constants.actionButtonBackgroundColor
        button.setTitleColor(Constants.actionButtonTitleColor, for: .normal)
        button.layer.cornerRadius = Constants.actionButtonCornerRadius
    }

    // MARK: - Actions
    @objc
    private func toggleSlidersVisibility() {
        slidersStack.isHidden.toggle()
    }
    
    @objc
    private func addWishButtonPressed() {
        present(WishStoringViewController(), animated: true)
    }
    
    @objc
    private func scheduleWishesButtonPressed() {
        let vc = WishCalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
