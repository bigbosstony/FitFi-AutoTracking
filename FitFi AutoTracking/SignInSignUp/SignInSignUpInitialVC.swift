//
//  ViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-07.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SVProgressHUD

class SignInSignUpInitialVC: UIViewController {
    

    
    var emailFB = ""
    var firstNameFB = ""
    var lastNameFB = ""
    var idFB = ""
    

    let loginManager = LoginManager()
    let loadingView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Default Facebook Login Button
//        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
//        let facebookIcon = UIImage(named: "Icons/facebook_icon")
        
        // Add a custom login button to your app
        let myLoginButton = BounceButton(type: .custom)
//        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor(red: 57/255, green: 86/255, blue: 156/255, alpha: 1)
        myLoginButton.layer.cornerRadius = 4
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        myLoginButton.center = view.center
        myLoginButton.setTitle("Continue With Facebook", for: .normal)

        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        // Add the button to the view
        view.addSubview(myLoginButton)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        loadingView.effect = blurEffect
        loadingView.frame = self.view.bounds
//        self.navigationController?.view.addSubview()
    }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (LoginResult) in
            switch LoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let token):
                print("Logged in!")
                
                print(grantedPermissions)
                print(declinedPermissions)
                print(token)
                
                //TODO: Add Loading View
                self.loadingView.alpha = 1
                self.view.addSubview(self.loadingView)
                SVProgressHUD.show()

//                if let window = UIApplication.shared.keyWindow {
////                    self.loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//
//                    //TODO: Add Loading View
//                    window.addSubview(self.loadingView)
//                    SVProgressHUD.show()
//
//                    self.loadingView.frame = window.frame
//                }
                
                // GraphRequest for Facebook
//                let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: [ "fields": "id, email, name, first_name, last_name, age_range, locale, timezone, gender,  picture.width(480).height(480)"] )
//                graphRequest.start { (response, result) in
//                    if response?.statusCode == 200 {
//                        print(result)
//                    }
//                }
                
                self.getFacebookAccountInfo()
 
            }
        }
    }
    
    func getFacebookAccountInfo() {
        
        let graphRequest = GraphRequest(graphPath: "me", parameters:  [ "fields": "id, email, name, first_name, last_name, age_range, locale, timezone, gender,  picture.width(480).height(480)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
        
        graphRequest.start({ (response, result) in
            switch result {
            case .success(let response):
                if let responseDictionary = response.dictionaryValue {
                    print(responseDictionary)
                    
                    self.firstNameFB = responseDictionary["first_name"] as? String ?? ""
                    self.lastNameFB = responseDictionary["last_name"] as? String ?? ""
                    self.emailFB = responseDictionary["email"] as? String ?? ""
                    self.idFB = responseDictionary["id"] as? String ?? ""
                    
                    self.makeCallToServer()
                    
                }
            case .failed(_): break
            }
        })
    }
    
    func makeCallToServer() {
        print("Check FB user")
        let url = baseURL + endURLCheckFBUserExist
        
        guard let fullURL = URL(string: url) else { print("Error: cannot create URL"); return }
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        
        //                    let data: [String: Any] = ["facebook": true, "facebookID": userID]
        let data: [String: Any] = ["email": self.emailFB, "app_key": app_key]
        
        let jsonData: Data
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                
                let statusCode = response.statusCode
                
                print("Response Status Code: ", response.statusCode)
                
                if statusCode == 200 {
                    
                } else if statusCode == 500 {
                    print("Inernal Server Error")
                    //TODO: Log out facebook
                    DispatchQueue.main.async {
                        self.loginManager.logOut()
//                        self.loadingView.alpha = 0

                        self.proceed(with: false)
                    }
                }
            }
            
            if let error = error {
                print("Error: ", error)
            }
            
            guard let data = data else { print("no data return"); return }
            
            do {
                guard let receivedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { print("nil return from server"); return }
                
                guard let status = receivedData["status"] as? Bool else { print("nil return"); return }
                
                DispatchQueue.main.async {
                    if Thread.isMainThread {
                        print("Thread is main")
                        self.proceed(with: status)
                    }
                }
            } catch {
                return
            }
        })
        task.resume()
    }
    
    func proceed(with status: Bool) {
        //If user has account with us go to home page
        if status {
            print("User Exist")
            //TODO: download user data to local
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedViewController")
            
            
            self.present(newViewController, animated: true, completion: nil)

            //TODO: Renove loading view
            self.loadingView.alpha = 0
            SVProgressHUD.dismiss()

        }
            //If user has no account with us, finish register
        else {
            print("User Not Exist")
            let storyBoard: UIStoryboard = UIStoryboard(name: "SignInSignUp", bundle: nil)
            let newNavController: UINavigationController = storyBoard.instantiateViewController(withIdentifier: "finishSignUpDetailWithSocialAccountNC") as UIViewController as! UINavigationController
            let destinationVC = newNavController.viewControllers.first as! SelectAgeViewController
            destinationVC.userInfo.emailAddress = self.emailFB
            destinationVC.userInfo.facebookID = self.idFB
            destinationVC.userInfo.firstName = self.firstNameFB
            destinationVC.userInfo.lastName = self.lastNameFB
            
            self.present(newNavController, animated: true, completion: nil)

            
            //TODO: Renove loading view
            self.loadingView.alpha = 0
            SVProgressHUD.dismiss()
            
        }
    }
    
}







