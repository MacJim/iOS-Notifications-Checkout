//
//  ViewController.swift
//  MJNotificationChecker
//
//  Created by Jim Shi on 2/2/20.
//  Copyright © 2020 Creative Sub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let notificationManager = NotificationManager.shared
        notificationManager.sendNotificationAfterTimeInterval(title: "Test", body: "Body", timeInterval: 2)
        notificationManager.unregisterNotification()
    }
}

