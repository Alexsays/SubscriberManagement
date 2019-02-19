//
//  Subscriber.swift
//  SubscriberManagement
//

import Foundation
import Firebase

struct Subscriber {

    enum State: String, CaseIterable {
        case active
        case unsubscribed

        var position: Int {
            return State.allCases.firstIndex(of: self) ?? 0
        }

        static func stateBy(_ active: Bool) -> State {
            return active ? .active : .unsubscribed
        }
    }

    var id: String
    var name: String
    var email: String
    var state: State
    var createdTimestamp: Timestamp
    var updatedTimestamp: Timestamp

    init(id: String = "", name: String, email: String,
         state: State, createdTimestamp: Timestamp, updatedTimestamp: Timestamp) {
        self.id = id
        self.name = name
        self.email = email
        self.state = state
        self.createdTimestamp = createdTimestamp
        self.updatedTimestamp = updatedTimestamp
    }

    func encodeAsDict() -> [String: Any] {
        return ["name": name,
                "email": email,
                "state": state.rawValue,
                "createdTimestamp": createdTimestamp,
                "updatedTimestamp": updatedTimestamp]
    }

}

extension QuerySnapshot {

    func decodeSubscribers() -> [Subscriber] {
        var subscribers: [Subscriber] = []
        documents.forEach { document in
            if let subscriber = document.decodeSubscriber() {
                subscribers.append(subscriber)
            }
        }
        return subscribers
    }

}

extension QueryDocumentSnapshot {

    func decodeSubscriber() -> Subscriber? {
        guard let name = data()["name"] as? String else { return nil }
        guard let email = data()["email"] as? String else { return nil }
        guard let stateString = data()["state"] as? String,
            let state = Subscriber.State(rawValue: stateString) else { return nil }
        guard let createdTimestamp = data()["createdTimestamp"] as? Timestamp else { return nil }
        guard let updatedTimestamp = data()["updatedTimestamp"] as? Timestamp else { return nil }
        return Subscriber(id: documentID,
                          name: name,
                          email: email,
                          state: state,
                          createdTimestamp: createdTimestamp,
                          updatedTimestamp: updatedTimestamp)
    }

}
