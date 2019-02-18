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

    private let stateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()

    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.drawText(in: CGRect(x: 5, y: 5, width: 5, height: 5))
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
//        stateView.centerYToSuperview()
//        stateView.rightToSuperview(offset: -16)
//        stateLabel.leftToSuperview(offset: 8)
//        stateLabel.topToSuperview(offset: 8)
//        stateLabel.rightToSuperview(offset: 8)
//        stateLabel.bottomToSuperview(offset: 8)
        stateLabel.centerYToSuperview()
        stateLabel.rightToSuperview(offset: -16)
    }

    func configureCell(withSubscriber subscriber: Subscriber) {
        nameLabel.text = subscriber.name
        emailLabel.text = subscriber.email
        stateLabel.text = subscriber.state.rawValue.uppercased()
        switch subscriber.state {
        case .active:
            stateLabel.layer.backgroundColor = UIColor.green.cgColor
        case .unsubscribed:
            stateLabel.layer.backgroundColor = UIColor.red.cgColor
        }
    }

    static func reuseIdentifier() -> String {
        return String(describing: self)
    }

}
