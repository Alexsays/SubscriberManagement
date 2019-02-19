//
//  AddSubscriberViewController.swift
//  SubscriberManagement
//

import UIKit
import SCLAlertView
import TinyConstraints

extension SubscriberListViewController {

    // MARK: Setup UI

    func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addTouched(_:)))
        navigationItem.rightBarButtonItems = [addButton]

    }

    func loadLayout() {
        view.addSubview(stateSegmentedControl)
        subscriberTableView.refreshControl = refreshControl
        view.addSubview(subscriberTableView)
    }

    func setupConstraints() {
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

    func setupDelegates() {
        subscriberTableView.delegate = self
        subscriberTableView.dataSource = self
    }

    // MARK: Helper methods

    func setupData() {
        APIClient.shared.getSubscribers { snapshot, error in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                if let error = error {
                    SCLAlertView.alertServerError(error.localizedDescription)
                } else {
                    guard let subscribers = snapshot?.decodeSubscribers() else { return }

                    self.allSubscribers = subscribers
                    self.subscribers = subscribers
                    self.filterSubscribers(state: FilterState(rawValue: self.stateSegmentedControl
                        .selectedSegmentIndex) ?? .all)
                    self.subscriberTableView.reloadData()
                }
            }
        }
    }

    func filterSubscribers(state: FilterState) {
        switch state {
        case .all:
            subscribers = allSubscribers
        case .active:
            subscribers = allSubscribers?.filter { $0.state == .active }
        case .unsubscribed:
            subscribers = allSubscribers?.filter { $0.state == .unsubscribed }
        }
    }

}
