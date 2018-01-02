//
//  Validator.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 2.01.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit
import Foundation

fileprivate struct ValidatorConstants {
    static let alertViewMessage = ""
    static let okAlertActionTitle = "OK"
    static let cancelAlertActionTitle = "Cancel"
}

struct Validator {
    static func addOkAllert(_ title: String,_ alertViewMessage: String = ValidatorConstants.alertViewMessage, okHandler: ((UIAlertAction) -> Swift.Void)? = nil) {

        // Create alert controller
        let alertView = UIAlertController(title: title, message: alertViewMessage, preferredStyle: .alert)

        // Create actions
        let ok = UIAlertAction(title: ValidatorConstants.okAlertActionTitle, style: .default, handler: okHandler)

        // Add the actions to the alert coontroller
        alertView.addAction(ok)

        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window, let visibleVC = window.visibleViewController {
            visibleVC.present(alertView, animated: true, completion: nil)
        }
    }

    static func addAllertWithCancelOption(_ title: String,_ alertViewMessage: String = ValidatorConstants.alertViewMessage, okHandler: ((UIAlertAction) -> Swift.Void)? = nil) {

        // Create alert controller
        let alertView = UIAlertController(title: title, message: alertViewMessage, preferredStyle: .alert)

        // Create actions
        let cancel = UIAlertAction(title: ValidatorConstants.cancelAlertActionTitle, style: .cancel, handler: nil)
        let ok = UIAlertAction(title: ValidatorConstants.okAlertActionTitle, style: .default, handler: okHandler)

        // Add the actions to the alert coontroller
        alertView.addAction(ok)
        alertView.addAction(cancel)

        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window, let visibleVC = window.visibleViewController {
            visibleVC.present(alertView, animated: true, completion: nil)
        }
    }
}
