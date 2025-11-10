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
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -150
        static let stackLeading: CGFloat = 20
        static let backgroundAlpha: CGFloat = 1
        static let toggleButtonTop: CGFloat = 10
        static let toggleButtonTitle: String = "Toggle Sliders"
        static let addWishButtonBackgroundColor: UIColor = .white
        static let addWishButtonTitleColor: UIColor = .systemPink
        static let addWishButtonHeight: CGFloat = 60
        static let addWishButtonBottom: CGFloat = 30
        static let addWishButtonSide: CGFloat = 20
        static let addWishButtonText: String = "Add Wish"
        static let addWishButtonRadius: CGFloat = 20
    }
    
    // MARK: - UI Elements
    private var titleView: UILabel = UILabel()
    private var descriptionView: UILabel = UILabel()
    private let slidersStack:UIStackView = UIStackView()
    private let addWishButton: UIButton = UIButton(type: .system)
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
        configureSliders()
        configureToggleButton()
        configureAddWishButton()
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
        slidersStack.layer.cornerRadius = Constants.stackRadius
        slidersStack.clipsToBounds = true
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            slidersStack.addArrangedSubview(slider)
        }
        NSLayoutConstraint.activate([
            slidersStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            slidersStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottom)
        ])
        
        let updateColor: () -> Void = { [weak self] in
            guard let self = self else { return }
            let r = CGFloat(sliderRed.slider.value)
            let g = CGFloat(sliderGreen.slider.value)
            let b = CGFloat(sliderBlue.slider.value)
            self.view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: Constants.backgroundAlpha)
        }

        sliderRed.valueChanged   = { _ in updateColor() }
        sliderGreen.valueChanged = { _ in updateColor() }
        sliderBlue.valueChanged  = { _ in updateColor() }
    }
    
    // MARK: - Toggle Button
    private func configureToggleButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.toggleButtonTitle, for: .normal)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: slidersStack.bottomAnchor, constant: Constants.toggleButtonTop),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        button.addTarget(self, action: #selector(toggleSlidersVisibility), for: .touchUpInside)
    }

    
    // MARK: - Add Wish Button
    private func configureAddWishButton() {
        view.addSubview(addWishButton)
        addWishButton.setHeight(Constants.addWishButtonHeight)
        addWishButton.pinBottom(to: view, Constants.addWishButtonBottom)
        addWishButton.pinHorizontal(to: view, Constants.addWishButtonSide)
        
        addWishButton.backgroundColor = Constants.addWishButtonBackgroundColor
        addWishButton.setTitleColor(Constants.addWishButtonTitleColor, for: .normal)
        addWishButton.setTitle(Constants.addWishButtonText, for: .normal)
        
        addWishButton.layer.cornerRadius = Constants.addWishButtonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
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
}
