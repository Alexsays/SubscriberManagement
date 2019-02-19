//
//  String+Extension.swift
//  SubscriberManagement
//

import Foundation
import FirebaseFirestore

typealias Localizable = R.string.localizable

extension Timestamp {

    func dateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        return dateFormatter.string(from: dateValue())
    }

}
