//
//  APIClient.swift
//  SubscriberManagement
//

import Foundation
import FirebaseFirestore

class APIClient {

    public static let shared = APIClient()

    private let subscribersRef = Firestore.firestore().collection("subscribers")

    func addSubscriber(_ subscriber: Subscriber,
                       completion: @escaping (Error?) -> Void) {
        subscribersRef.addDocument(data: subscriber.encodeAsDict(), completion: completion)
    }

    func updatedSubscriber(_ subscriberID: String,
                           subscriber: Subscriber,
                           completion: @escaping (Error?) -> Void) {
        subscribersRef.document(subscriberID).updateData(subscriber.encodeAsDict(), completion: completion)
    }

    func removeSubscriber(_ subscriberID: String,
                          completion: @escaping (Error?) -> Void) {
        subscribersRef.document(subscriberID).delete(completion: completion)
    }

    func getSubscribers(_ completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        subscribersRef.getDocuments(completion: completion)
    }
    
}
