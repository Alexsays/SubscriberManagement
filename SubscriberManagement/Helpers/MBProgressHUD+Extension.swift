//
//  MBProgressHUD+Extension.swift
//  SubscriberManagement
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {

    @discardableResult static func showAdded(to view: UIView,
                                             mode: MBProgressHUDMode = .indeterminate,
                                             text: String? = nil,
                                             color: UIColor = .clear,
                                             style: MBProgressHUDBackgroundStyle = .solidColor,
                                             animated: Bool) -> MBProgressHUD {
        let hud = MBProgressHUD(view: view)
        if let text = text {
            hud.mode = .customView
            hud.customView = UIImageView(image: R.image.checkmark()?.withRenderingMode(.alwaysTemplate))
            hud.label.font = .systemFont(ofSize: 20, weight: .heavy)
            hud.label.text = text
        } else {
            hud.mode = mode
        }
        hud.backgroundView.style = style
        hud.contentColor = color
        hud.removeFromSuperViewOnHide = true
        view.addSubview(hud)
        hud.show(animated: animated)
        return hud
    }

}
