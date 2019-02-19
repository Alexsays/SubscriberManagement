//
//  SubscriberTableViewCell.swift
//  SubscriberManagement
//

import UIKit
import TinyConstraints

class SubscriberTableViewCell: UITableViewCell {

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()

    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        loadLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadLayout()
    }

    private func loadLayout() {
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(emailLabel)
        addSubview(mainStackView)
        addSubview(stateLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        mainStackView.leftToSuperview(offset: 16)
        mainStackView.topToSuperview(offset: 8)
        mainStackView.bottomToSuperview(offset: -8)
        stateLabel.centerYToSuperview()
        stateLabel.rightToSuperview(offset: -16)
    }

    func configureCell(withSubscriber subscriber: Subscriber) {
        nameLabel.text = subscriber.name
        emailLabel.text = subscriber.email
        stateLabel.text = subscriber.state.rawValue.uppercased()
        switch subscriber.state {
        case .active:
            stateLabel.textColor = .successGreen
        case .unsubscribed:
            stateLabel.textColor = .dangerRed
        }
    }

    static let reuseIdentifier: String = {
        return String(describing: self)
    }()

}
