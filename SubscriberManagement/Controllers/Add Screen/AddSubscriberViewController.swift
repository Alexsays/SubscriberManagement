//
//  AddSubscriberViewController.swift
//  SubscriberManagement
//

import UIKit
import FirebaseFirestore
import MBProgressHUD
import SCLAlertView

class AddSubscriberViewController: ViewController {

    // MARK: UI components

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()

    let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.name()
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 20, weight: .heavy)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.placeholder = Localizable.add()
        textField.tag = 0
        return textField
    }()

    let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.email()
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 20, weight: .heavy)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.placeholder = Localizable.add()
        textField.tag = 1
        return textField
    }()

    let stateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.state()
        return label
    }()

    let stateHorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    let stateLabelValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.text = Subscriber.State.unsubscribed.rawValue.uppercased()
        label.textColor = .dangerRed
        return label
    }()

    let stateSwitch: UISwitch = {
        let sSwitch = UISwitch()
        sSwitch.tintColor = .dangerRed
        sSwitch.backgroundColor = .dangerRed
        sSwitch.layer.cornerRadius = sSwitch.frame.height / 2
        sSwitch.onTintColor = .successGreen
        sSwitch.addTarget(self,
                          action: #selector(stateValueChanged(_:)),
                          for: .touchUpInside)
        return sSwitch
    }()

    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localizable.add_subscriber(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .mlGreen
        button.layer.cornerRadius = 5
        button.addTarget(self,
                         action: #selector(addTouched(_:)),
                         for: .touchUpInside)
        return button
    }()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLayout()
        setupConstraints()
        setupDelegates()
        addKeyboardDismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = Localizable.add_subscriber()
    }

    // MARK: Actions

    @objc func stateValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            stateLabelValue.textColor = .successGreen
            stateLabelValue.text = Subscriber.State.active.rawValue.uppercased()
        } else {
            stateLabelValue.textColor = .dangerRed
            stateLabelValue.text = Subscriber.State.unsubscribed.rawValue.uppercased()
        }
    }

    @objc private func addTouched(_ sender: UIButton) {
        animateButton(sender)

        guard !existsEmptyField() else {
            return
        }

        let subscriber = Subscriber(name: nameTextField.text!,
                        email: emailTextField.text!,
                        state: .stateBy(stateSwitch.isOn),
                        createdTimestamp: Timestamp(date: Date()),
                        updatedTimestamp: Timestamp(date: Date()))

        MBProgressHUD.showAdded(to: view, color: .mlGreen, animated: true)
        APIClient.shared.addSubscriber(subscriber) { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    SCLAlertView.alertServerError(error.localizedDescription)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

}

private typealias TextFieldMethods = AddSubscriberViewController
extension TextFieldMethods: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let type = ValidatorType(rawValue: textField.tag), let text = textField.text else { return }

        switch Validator.shared.validate(text.trimmingCharacters(in: .whitespacesAndNewlines), type: type) {
        case .success:
            break
        case .failure(let errorResult):
            SCLAlertView.alertValidationError(result: .failure(errorResult))
            textField.becomeFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }

}
