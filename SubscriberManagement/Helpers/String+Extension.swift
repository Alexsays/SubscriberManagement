//
//  String+Extension.swift
//  SubscriberManagement
//

import Foundation

typealias Localizable = R.string.localizable

protocol StringRawRepresentable {
    var stringRawValue: String { get }
}

extension StringRawRepresentable where Self: RawRepresentable, Self.RawValue == String {
    var stringRawValue: String { return rawValue }
}
