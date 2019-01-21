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
            nextButton.backgroundColor = UIColor.init(red: 246/255, green: 120/255, blue: 12/255, alpha: 1)
            if gender[0] {
                maleButton.alpha = 1
                femaleButton.alpha = 0.25
            } else {
                maleButton.alpha = 0.25
                femaleButton.alpha = 1
            }
        }
    }
    
    var femaleButton = UIButton()
    var maleButton = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Tab bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let femaleImage = UIImage(named: "Icons/genderFemale")
        let maleImage = UIImage(named: "Icons/genderMale")
        
        let sideLength = self.view.frame.width / 2 - 30
        
        
        femaleButton = UIButton(frame: CGRect(x: 20, y: 215, width: sideLength, height: sideLength))
        femaleButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        femaleButton.setImage(femaleImage, for: UIControl.State.normal)
        femaleButton.addTarget(self, action: #selector(femaleButtonPressed), for: UIControl.Event.touchUpInside)
        femaleButton.alpha = 0.25
        
        maleButton = UIButton(frame: CGRect(x: (20 + sideLength + 10), y: 215, width: sideLength, height: sideLength))
        maleButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        maleButton.setImage(maleImage, for: UIControl.State.normal)
        maleButton.addTarget(self, action: #selector(maleButtonPressed), for: UIControl.Event.touchUpInside)
        maleButton.alpha = 0.25
        
        view.addSubview(femaleButton)
        view.addSubview(maleButton)
    }

    @objc func femaleButtonPressed() {
        femaleButton.pulsate()
        userInfo.gender = 1
        gender[0] = false
        gender[1] = true
    }
    
    @objc func maleButtonPressed() {
        maleButton.pulsate()
        userInfo.gender = 0
        gender[0] = true
        gender[1] = false
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
            } else {
                sender.shake()
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
