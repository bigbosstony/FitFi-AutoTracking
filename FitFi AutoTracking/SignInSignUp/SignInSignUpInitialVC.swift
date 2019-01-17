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

class SignInSignUpInitialVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Default Facebook Login Button
//        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
        let facebookIcon = UIImage(named: "Icons/facebook_icon")
        
        // Add a custom login button to your app
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor(red: 57/255, green: 86/255, blue: 156/255, alpha: 1)
        myLoginButton.layer.cornerRadius = 4
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        myLoginButton.center = view.center
        myLoginButton.setTitle("Continue With Facebook", for: .normal)

        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        // Add the button to the view
        view.addSubview(myLoginButton)
        
        
//        self.navigationController?.view.addSubview()
    }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        
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
                
                // GraphRequest for Facebook
//                let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: [ "fields": "id, email, name, first_name, last_name, age_range, locale, timezone, gender,  picture.width(480).height(480)"] )
//                graphRequest.start { (response, result) in
//                    if response?.statusCode == 200 {
//                        print(result)
//                    }
//                }
                
                let graphRequest = GraphRequest(graphPath: "me", parameters:  [ "fields": "id, email, name, first_name, last_name, age_range, locale, timezone, gender,  picture.width(480).height(480)"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
                
                graphRequest.start({ (response, result) in
                    switch result {
                        
                    case .success(let response):
                        if let responseDictionary = response.dictionaryValue {
                            print(responseDictionary)
                            
                            let firstNameFB = responseDictionary["first_name"] as? String
                            let lastNameFB = responseDictionary["last_name"] as? String
                            let emailFB = responseDictionary["email"] as? String
                            let idFB = responseDictionary["id"] as? String
                            
                            let storyBoard: UIStoryboard = UIStoryboard(name: "SignInSignUp", bundle: nil)
                            let newNavController: UINavigationController = storyBoard.instantiateViewController(withIdentifier: "finishSignUpDetailWithSocialAccountNC") as UIViewController as! UINavigationController
                            let destinationVC = newNavController.viewControllers.first as! SelectAgeViewController
                            destinationVC.userInfo.emailAddress = emailFB
                            destinationVC.userInfo.facebookID = idFB
                            destinationVC.userInfo.firstName = firstNameFB
                            destinationVC.userInfo.lastName = lastNameFB
                            
                            self.present(newNavController, animated: true, completion: nil)
                        }
                    case .failed(_): break
                        
                    }
                })
                
                
                
                if let userID = token.userId {
                    print("userID")
                    let url = "www.fitfi.ai" + ""
                    guard let fullURL = URL(string: url) else { print("Error: cannot create URL"); return }

                    var request = URLRequest(url: fullURL)
                    request.httpMethod = "POST"

                    let data: [String: Any] = ["facebook": true, "facebookID": userID]
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
                        
                        guard let data = data else { print("no data return"); return }

                        do {
                            guard let receivedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { print("nil return from server"); return }

                            guard let userExist = receivedData["userExist"] as? Bool else { print("nil return"); return }
                            
                            //If user has account with us go to home page
                            if userExist {
                                print("User Exist")
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedViewController")
                                self.present(newViewController, animated: true, completion: nil)
                            }
                            //If user has no account with us, finish register
                            else {
                                print("User Not Exist")
                                let storyBoard: UIStoryboard = UIStoryboard(name: "SignInSignUp", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SocialDetailsViewController")
                                self.present(newViewController, animated: true, completion: nil)
                            }
                        } catch {
                            return
                        }
                    })
                    task.resume()
                }
            }
        }
    }
}






