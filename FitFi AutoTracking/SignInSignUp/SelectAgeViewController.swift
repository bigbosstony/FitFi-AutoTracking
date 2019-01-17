//
//  SelectAgeViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-17.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit
import FacebookLogin

class SelectAgeViewController: UIViewController {

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var userInfo = userAccountInfoFacebook() {
        didSet {
//            let mirror = Mirror(reflecting: userInfo)
            print("User Info Set")
            print(userInfo)
        }
    }
    
    var gender: [Bool] = [false, false] {
        didSet {
            nextButton.backgroundColor = UIColor.blue
            if gender[0] {
                maleButton.backgroundColor = UIColor.blue
                maleButton.setTitleColor(UIColor.white, for: .normal)
                femaleButton.backgroundColor = UIColor.white
                femaleButton.setTitleColor(UIColor.blue, for: .normal)
            } else {
                femaleButton.backgroundColor = UIColor.blue
                femaleButton.setTitleColor(UIColor.white, for: .normal)
                maleButton.backgroundColor = UIColor.white
                maleButton.setTitleColor(UIColor.blue, for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Tab bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        userInfo.gender = 0
        gender[0] = true
        gender[1] = false
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        userInfo.gender = 1
        gender[0] = false
        gender[1] = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let loginManager = LoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        for value in gender {
            if value {
                performSegue(withIdentifier: "goToFinishProfileSetupVC", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFinishProfileSetupVC" {
            let destinationVC = segue.destination as! FinishProfileSetupVC
            destinationVC.userInfo = userInfo
        }
    }
    
}
