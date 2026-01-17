//
//  CustomSlider.swift
//  tvchekmarevPW2
//
//  Created by Трофим Чекмарев on 01.10.2025.
//

import UIKit

final class CustomSlider: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let titleTop: CGFloat = 10
        static let titleLeading: CGFloat = 20
        static let sliderBottom: CGFloat = -10
        static let sliderLeading: CGFloat = 20
    }
    // MARK: - Properties
    var valueChanged: ((Double) -> Void)?
    
    // MARK: - UI Elements
    var slider = UISlider()
    var titleView = UILabel()
    
    // MARK: - Initialization
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        for view in [slider, titleView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleTop),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLeading),
            
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.sliderBottom),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sliderLeading)
        ])
    }
    
    // MARK: - Actions
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
