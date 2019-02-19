//
//  SubscriberListViewController.swift
//  SubscriberManagement
//

import UIKit
import MBProgressHUD
import SCLAlertView
import TinyConstraints

class SubscriberListViewController: ViewController {

    enum FilterState: Int {
        case all = 0
        case active
        case unsubscribed
    }

    // MARK: UI components

    let stateSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Localizable.all(),
                                                          Localizable.active(),
                                                          Localizable.unsuscribed()])
        segmentedControl.tintColor = .mlGreen
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    let subscriberTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(SubscriberTableViewCell.self,
                           forCellReuseIdentifier: SubscriberTableViewCell.reuseIdentifier)
        return tableView
    }()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .mlGreen
        refreshControl.addTarget(self,
                                 action: #selector(refreshSubscribers(_:)),
                                 for: .valueChanged)
        return refreshControl
    }()

    var subscribers: [Subscriber]?
    var allSubscribers: [Subscriber]?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        loadLayout()
        setupConstraints()
        setupDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = Localizable.subscribers()
        setupData()
    }

    // MARK: Actions

    @objc func addTouched(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(AddSubscriberViewController(), animated: true)
    }

    @objc private func filterValueChanged(_ sender: UISegmentedControl) {
        guard let filterState = FilterState(rawValue: sender.selectedSegmentIndex) else {
            return
        }

        filterSubscribers(state: filterState)

        subscriberTableView.reloadData()
    }

    @objc func refreshSubscribers(_ sender: UIRefreshControl) {
        setupData()
    }

}

private typealias TableViewMethods = SubscriberListViewController
extension TableViewMethods: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let subscribers = subscribers else { return 0 }
        return subscribers.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let subscribers = subscribers else { return UITableViewCell() }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubscriberTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SubscriberTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(withSubscriber: subscribers[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let subscribers = subscribers else { return }

        if editingStyle == .delete {
            MBProgressHUD.showAdded(to: view, color: .mlGreen, animated: true)
            APIClient.shared.removeSubscriber(subscribers[indexPath.row].id) { error in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if let error = error {
                        SCLAlertView.alertServerError(error.localizedDescription)
                    } else {
                        self.subscribers = self.subscribers?.filter { $0.id != subscribers[indexPath.row].id }
                        self.allSubscribers = self.allSubscribers?.filter { $0.id != subscribers[indexPath.row].id }
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let subscribers = subscribers else { return }

        tableView.deselectRow(at: indexPath, animated: true)

        let detailSubscriberVC = DetailSubscriberViewController()
        detailSubscriberVC.subscriber = subscribers[indexPath.row]
        navigationController?.pushViewController(detailSubscriberVC, animated: true)
    }

}
