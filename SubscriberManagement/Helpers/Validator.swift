//
//  Validator.swift
//  SubscriberManagement
//

import Foundation

enum ValidatorResult {
    case success
    case failure(ValidatorErrorMessages)
}

enum ValidatorErrorMessages: String {
    case emptyFieldAll = "empty_field_all"
    case invalidCharacters = "invalid_characters"
    case invalidEmail = "invalid_email"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum ValidatorType: Int {
    case name
    case email
}

enum ValidatorRegex: String {
    case charactersWithoutNumSymb = "^[a-zA-ZáéíúóÁÉÍÓÚñÑ ]*$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
}

class Validator {

    public static let shared = Validator()

    func validate(_ value: String?, type: ValidatorType) -> ValidatorResult {
        return validateString(value, type: type)
    }

    private func validateString(_ value: String?, type: ValidatorType) -> ValidatorResult {
        guard let value = value, !value.isEmpty else {
            return .success
        }

        switch type {
        case .name:
            return validateRegex(value, regex: .charactersWithoutNumSymb)
        case .email:
            return validateRegex(value, regex: .email)
        }
    }

    private func validateRegex(_ value: String, regex: ValidatorRegex) -> ValidatorResult {
        var stringTest: NSPredicate
        switch regex {
        case .charactersWithoutNumSymb:
            stringTest = NSPredicate(format: "SELF MATCHES %@", regex.rawValue)
            return stringTest.evaluate(with: value) ? .success : .failure(.invalidCharacters)
        case .email:
            stringTest = NSPredicate(format: "SELF MATCHES %@", regex.rawValue)
            return stringTest.evaluate(with: value) ? .success : .failure(.invalidEmail)
        }
    }

}
