//
//  DetailSubscriberViewController.swift
//  SubscriberManagement
//

import UIKit
import FirebaseFirestore
import MBProgressHUD
import SCLAlertView

class DetailSubscriberViewController: ViewController {

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
        textField.isUserInteractionEnabled = false
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
        textField.isUserInteractionEnabled = false
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

    let datesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()

    let createdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    let createdLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.created_date()
        return label
    }()

    let createdValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    let updatedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    let updatedLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.updated_date()
        return label
    }()

    let updatedValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()

    let editSaveButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localizable.edit_subscriber(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .mlGreen
        button.layer.cornerRadius = 5
        button.addTarget(self,
                         action: #selector(editTouched(_:)),
                         for: .touchUpInside)
        return button
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localizable.cancel(), for: .normal)
        button.setTitleColor(.mlGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.mlGreen.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self,
                         action: #selector(cancelTouched(_:)),
                         for: .touchUpInside)
        return button
    }()

    var subscriber: Subscriber!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLayout()
        setupConstraints()
        setupDelegates()
        addKeyboardDismiss()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = Localizable.detail()
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

    @objc func editTouched(_ sender: UIButton) {
        animateButton(sender)

        editUI()
    }

    @objc func cancelTouched(_ sender: UIButton) {
        animateButton(sender)

        resetUI()
    }

    @objc func saveTouched(_ sender: UIButton) {
        animateButton(sender)

        guard !existsEmptyField() else {
            return
        }

        let subscriber = Subscriber(id: self.subscriber.id,
                                    name: nameTextField.text!,
                                    email: emailTextField.text!,
                                    state: .stateBy(stateSwitch.isOn),
                                    createdTimestamp: self.subscriber.createdTimestamp,
                                    updatedTimestamp: Timestamp(date: Date()))

        MBProgressHUD.showAdded(to: view, color: .mlGreen, animated: true)
        APIClient.shared.updatedSubscriber(self.subscriber.id, subscriber: subscriber) { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                let hud = MBProgressHUD.showAdded(to: self.view,
                                        text: Localizable.subscriber_saved(),
                                        color: .mlGreen,
                                        animated: true)
                hud.hide(animated: true, afterDelay: 1)
                if let error = error {
                    SCLAlertView.alertServerError(error.localizedDescription)
                } else {
                    self.subscriber = subscriber
                    self.setupData()
                    self.resetUI()
                }
            }
        }
    }

}

private typealias TextFieldMethods = DetailSubscriberViewController
extension TextFieldMethods: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = .lightGray

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
