//
//  AddSubscriberMethods.swift
//  SubscriberManagement
//

import UIKit
import TinyConstraints

extension AddSubscriberViewController {

    // MARK: Setup UI

    func loadLayout() {
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        stateStackView.addArrangedSubview(stateLabel)
        stateHorStackView.addArrangedSubview(stateLabelValue)
        stateHorStackView.addArrangedSubview(stateSwitch)
        stateStackView.addArrangedSubview(stateHorStackView)
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(emailStackView)
        mainStackView.addArrangedSubview(stateStackView)
        view.addSubview(mainStackView)
        view.addSubview(addButton)
    }

    func setupConstraints() {
        addButton.height(60)
        mainStackView.edgesToSuperview(excluding: .bottom,
                                       insets: TinyEdgeInsets(top: 16, left: 16, bottom: 0, right: 16),
                                       usingSafeArea: true)
        addButton.edgesToSuperview(excluding: .top,
                                   insets: TinyEdgeInsets(top: 0, left: 16, bottom: 16, right: 16),
                                   usingSafeArea: true)

    }

    func setupDelegates() {
        nameTextField.delegate = self
        emailTextField.delegate = self
    }

    // MARK: Helper methods

    func existsEmptyField() -> Bool {
        guard let name = nameTextField.text else { return true }
        guard let email = emailTextField.text else { return true }

        return name.isEmpty || email.isEmpty
    }

}
