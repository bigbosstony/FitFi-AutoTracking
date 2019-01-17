//
//  FeedViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-14.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        Default Facebook Login Button
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
}
