//
//  ViewController.swift
//  SubscriberManagement
//

import UIKit
import FirebaseFirestore
import TinyConstraints

class SubscriberListViewController: ViewController {

    private enum FilterState: Int {
        case all = 0
        case active
        case unsubscribed
    }

    // MARK: UI components

    private let stateSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Localizable.all(),
                                                          Localizable.active(),
                                                          Localizable.unsuscribed()])
        segmentedControl.tintColor = .greenMailerLite
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    private let subscriberTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(SubscriberTableViewCell.self,
                           forCellReuseIdentifier: SubscriberTableViewCell.reuseIdentifier())
        return tableView
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .greenMailerLite
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

        setupNavigation()
        loadLayout()
        setupConstraints()
        setupDelegates()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = Localizable.mailerLite()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        title = ""
    }

    private func setupData() {
        stateSegmentedControl.selectedSegmentIndex = FilterState.all.rawValue
        Firestore.firestore().collection("subscribers").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let subscribers = snapshot?.decodeSubscribers() else { return }

                    self.allSubscribers = subscribers
                    self.subscribers = subscribers
                    self.subscriberTableView.reloadData()
                }
            }
        }
    }

    // MARK: Setup UI

    private func setupNavigation() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addTouched(_:)))
        navigationItem.rightBarButtonItems = [addButton]
    }

    private func loadLayout() {
        view.addSubview(stateSegmentedControl)
        subscriberTableView.refreshControl = refreshControl
        view.addSubview(subscriberTableView)
    }

    private func setupConstraints() {
        stateSegmentedControl.edgesToSuperview(excluding: .bottom,
                                               insets: TinyEdgeInsets(top: 8,
                                                                      left: 16,
                                                                      bottom: 0,
                                                                      right: 16),
                                               usingSafeArea: true)
        subscriberTableView.topToBottom(of: stateSegmentedControl, offset: 8)
        subscriberTableView.edgesToSuperview(excluding: .top,
                                             usingSafeArea: true)
    }

    private func setupDelegates() {
        subscriberTableView.delegate = self
        subscriberTableView.dataSource = self
    }

    // MARK: Actions

    @objc private func addTouched(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(AddSubscriberViewController(), animated: true)
    }

    @objc private func filterValueChanged(_ sender: UISegmentedControl) {
        guard let filterState = FilterState(rawValue: sender.selectedSegmentIndex) else {
            return
        }

        switch filterState {
        case .all:
            subscribers = allSubscribers
        case .active:
            subscribers = allSubscribers?.filter { $0.state == .active }
        case .unsubscribed:
            subscribers = allSubscribers?.filter { $0.state == .unsubscribed }
        }

        subscriberTableView.reloadData()
    }

    @objc private func refreshSubscribers(_ sender: UIRefreshControl) {
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubscriberTableViewCell.reuseIdentifier(),
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
            Firestore.firestore().collection("subscribers").document(subscribers[indexPath.row].id).delete { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.subscribers = self.subscribers?.filter { $0.id != subscribers[indexPath.row].id }
                        self.allSubscribers = self.allSubscribers?.filter { $0.id != subscribers[indexPath.row].id }
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

}
