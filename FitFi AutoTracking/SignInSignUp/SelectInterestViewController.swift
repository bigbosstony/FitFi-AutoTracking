//
//  SelectInterestViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-29.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class SelectInterestViewController: UIViewController {

    
    var selectedMuscleGroupArray: [Muscle] = [] {
        didSet {
            print("++", self.selectedMuscleGroupArray)
        }
    }
    
    var userInfo = userAccountInfoFacebook() {
        didSet {
            print("++", self.userInfo)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.navigationItem.hidesBackButton = true
        
        // TODO: prepare data for server
        
        
    }
    

    
    @IBAction func goToAppButtonPressed(_ sender: UIButton) {
        print("registering")
        
        //TODO: Send Data to Server
        
        
        
        //TODO: Save Data to Userdefaults
        UserDefaults.standard.set(userInfo.emailAddress, forKey: "email")
        
        
        //MARK: Proceed to Home Screen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        self.present(tabBarViewController, animated: true, completion: nil)
        
        
//        let url = baseURL + endURLRegisterFBUser
//
//        guard let fullURL = URL(string: url) else { print("Error: cannot create URL"); return }
//
//        var request = URLRequest(url: fullURL)
//        request.httpMethod = "POST"
//
//        //                    let data: [String: Any] = ["facebook": true, "facebookID": userID]
//        let data: [String: Any] = ["thirdparty": "facebook", "email": userInfo.emailAddress ?? "", "facebook_id": userInfo.facebookID ?? "", "first_name": userInfo.firstName ?? "", "last_name": userInfo.lastName ?? "", "age": String(userInfo.age!), "gender": String(userInfo.gender!), "height": String(userInfo.height!), "weight": String(userInfo.weight!), "h_metric": userInfo.heightUnit , "w_metric": userInfo.weightUnit , "desired_weight": "10", "app_key": app_key]
//
//        let jsonData: Data
//
//        do {
//            jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//        } catch {
//            print("Error: cannot create JSON from")
//            return
//        }
//
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
//
//            guard let data = data else { print("no data return"); return }
//
//            do {
//                guard let receivedData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { print("nil return from server"); return }
//
//                guard let status = receivedData[0]["status"] as? Bool else { print("nil return"); return }
//
//                //If user has account with us go to home page
//                if status {
//                    print("Finish Registering")
//                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
//                    self.present(newViewController, animated: true, completion: nil)
//                }
//            } catch {
//                return
//            }
//        })
//        task.resume()
    }
}
