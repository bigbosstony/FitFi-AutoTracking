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

    let loginManager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()

//        Default Facebook Login Button
        let logoutButton = UIButton(type: .custom)
        logoutButton.frame = CGRect(x: 0, y: 500, width: 200, height: 40)
        logoutButton.backgroundColor = UIColor.blue
        
        logoutButton.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        

    }
    
    @objc func logoutUser() {
        if AccessToken.current != nil {
            loginManager.logOut()
            // go to sign in vc
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "SignInSignUp", bundle: nil)
            let signInSignUpRootNC : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "signInSignIpViewController")
            self.present(signInSignUpRootNC, animated: true, completion: nil)
        }
    }
}
