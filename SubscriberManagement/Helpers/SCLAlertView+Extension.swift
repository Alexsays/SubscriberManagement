//
//  SCLAlertView+Extension.swift
//  SubscriberManagement
//

import UIKit
import SCLAlertView

extension SCLAlertView {

    static func alertValidationError(result: ValidatorResult) {
        var description = ""

        switch result {
        case .success:
            break
        case .failure(let descriptionType):
            description = descriptionType.localized()
        }

        let alert = SCLAlertView()

        alert.showWarning(Localizable.validation_error(),
                          subTitle: description,
                          closeButtonTitle: Localizable.accept())
    }

    static func alertServerError(_ serverMessage: String) {
        let alert = SCLAlertView()

        alert.showWarning(Localizable.server_error(),
                          subTitle: serverMessage,
                          closeButtonTitle: Localizable.accept())
    }

}
