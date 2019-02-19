//
//  DetailSubscriberMethods.swift
//  SubscriberManagement
//

import UIKit
import TinyConstraints

extension DetailSubscriberViewController {

    // MARK: Setup UI

    func loadLayout() {
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        stateStackView.addArrangedSubview(stateLabel)
        stateHorStackView.addArrangedSubview(stateLabelValue)
        stateStackView.addArrangedSubview(stateHorStackView)
        createdStackView.addArrangedSubview(createdLabel)
        createdStackView.addArrangedSubview(createdValueLabel)
        updatedStackView.addArrangedSubview(updatedLabel)
        updatedStackView.addArrangedSubview(updatedValueLabel)
        datesStackView.addArrangedSubview(createdStackView)
        datesStackView.addArrangedSubview(updatedStackView)
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(emailStackView)
        mainStackView.addArrangedSubview(stateStackView)
        mainStackView.addArrangedSubview(datesStackView)
        view.addSubview(mainStackView)

        buttonStackView.addArrangedSubview(editSaveButton)
        view.addSubview(buttonStackView)
    }

    func setupConstraints() {
        editSaveButton.height(60)
        cancelButton.height(60)
        mainStackView.edgesToSuperview(excluding: .bottom,
                                       insets: TinyEdgeInsets(top: 16, left: 16, bottom: 0, right: 16),
                                       usingSafeArea: true)
        buttonStackView.edgesToSuperview(excluding: .top,
                                         insets: TinyEdgeInsets(top: 0, left: 16, bottom: 16, right: 16),
                                         usingSafeArea: true)

    }

    func setupDelegates() {
        nameTextField.delegate = self
        emailTextField.delegate = self
    }

    func setupData() {
        nameTextField.text = subscriber.name
        emailTextField.text = subscriber.email
        stateLabelValue.text = subscriber.state.rawValue.uppercased()
        switch subscriber.state {
        case .active:
            stateLabelValue.textColor = .successGreen
        case .unsubscribed:
            stateLabelValue.textColor = .dangerRed
        }
        stateSwitch.isOn = subscriber.state == .active
        createdValueLabel.text = subscriber.createdTimestamp.dateAsString()
        updatedValueLabel.text = subscriber.updatedTimestamp.dateAsString()
    }

    // MARK: Helper methods

    func existsEmptyField() -> Bool {
        guard let name = nameTextField.text else { return true }
        guard let email = emailTextField.text else { return true }

        return name.isEmpty || email.isEmpty
    }

    func editUI() {
        title = Localizable.edit()
        editSaveButton.removeTarget(nil,
                                    action: nil,
                                    for: .allEvents)
        editSaveButton.addTarget(self,
                                 action: #selector(saveTouched(_:)),
                                 for: .touchUpInside)
        editSaveButton.setTitle(Localizable.save(),
                                for: .normal)
        stateHorStackView.addArrangedSubview(stateSwitch)
        buttonStackView.addArrangedSubview(cancelButton)
        mainStackView.removeArrangedSubview(datesStackView)
        datesStackView.removeFromSuperview()
        nameTextField.isUserInteractionEnabled = true
        nameTextField.textColor = .lightGray
        emailTextField.isUserInteractionEnabled = true
        emailTextField.textColor = .lightGray

        UIView.animate(withDuration: 0.1) {
            self.stateStackView.layoutIfNeeded()
            self.buttonStackView.layoutIfNeeded()
        }
    }

    func resetUI() {
        dismissKeyboard()
        setupData()
        title = Localizable.detail()
        editSaveButton.removeTarget(nil,
                                    action: nil,
                                    for: .allEvents)
        editSaveButton.addTarget(self,
                                 action: #selector(editTouched(_:)),
                                 for: .touchUpInside)
        editSaveButton.setTitle(Localizable.edit_subscriber(),
                                for: .normal)
        stateHorStackView.removeArrangedSubview(stateSwitch)
        stateSwitch.removeFromSuperview()
        buttonStackView.removeArrangedSubview(cancelButton)
        cancelButton.removeFromSuperview()
        mainStackView.addArrangedSubview(datesStackView)
        nameTextField.isUserInteractionEnabled = false
        nameTextField.textColor = .black
        emailTextField.isUserInteractionEnabled = false
        emailTextField.textColor = .black

        UIView.animate(withDuration: 0.1) {
            self.stateStackView.layoutIfNeeded()
            self.buttonStackView.layoutIfNeeded()
        }
    }

}
