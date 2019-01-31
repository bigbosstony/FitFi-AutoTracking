//
//  SignInAndUpHomeViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-31.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class SignInAndUpHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func getStartButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUpVC", sender: self)
    }
    
}
