//
//  SettingsViewController.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 2.01.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    // MARK: - Outlets and outlet functions
    @IBOutlet weak var localNotificarionsSwitch: UISwitch!

    @IBAction func didTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    self.openSettings()
                }
            }
        } else {
            openSettings()
        }
    }
    // MARK: - Variables
    let center = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]

    // MARK: - Functions
    private func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - View Lifecycle
    fileprivate func extractedFunc() {
        center.getNotificationSettings { (notificationsSettings) in
            DispatchQueue.main.async {
                self.localNotificarionsSwitch.setOn(notificationsSettings.authorizationStatus == .authorized, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extractedFunc()
    }
}
