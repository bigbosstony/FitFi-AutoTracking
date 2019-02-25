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

class SignUpInitialVC: UIViewController {
    
    var emailFB = ""
    var firstNameFB = ""
    var lastNameFB = ""
    var idFB = ""
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    

    let loginManager = LoginManager()
    let loadingView = UIVisualEffectView()

    let receivedData: [String: Any] = [:]
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        scrollView.touchesShouldCancel(in: view)
        
        scrollView.delegate = self
//        scrollView.keyboardDismissMode = .onDrag
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        firstNameTextField.tag = 0
        lastNameTextField.tag = 1
        emailTextField.tag = 2
        passwordTextField.tag = 3
        
        let width = self.view.frame.width
        
        // Add a custom login button to your app
        let myLoginButton = BounceButton(type: .custom)
        myLoginButton.backgroundColor = UIColor(red: 57/255, green: 86/255, blue: 156/255, alpha: 1)
        myLoginButton.layer.cornerRadius = 4
        myLoginButton.frame = CGRect(x: 40, y: 30, width: width - 80, height: 40)
//        myLoginButton.center = view.center
        myLoginButton.setTitle("Continue With Facebook", for: .normal)

        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        // Add the button to the view
        contentView.addSubview(myLoginButton)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        loadingView.effect = blurEffect
        loadingView.frame = self.view.bounds
//        self.navigationController?.view.addSubview()
        
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    //get user facebook account basic info
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
                    
                    self.makeCallToServer(completion: { (receivedData) in
                        print("Received data: ", receivedData)
                    })
                }
            case .failed(_): break
            }
        })
    }
    
    
    //TODO: Change to Generic Function
    func makeCallToServer(completion: @escaping ([String: Any]) -> ()) {
        print("Check FB user")
        
        
//        let url = baseURL + endURLCheckFBUserExist
        let url = "https://www.google.com"
        
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
                
                if statusCode != 200 {
                    
                    print("Inernal Server Error")
                    //TODO: Log out facebook, Remain in the screen
                    DispatchQueue.main.async {
                        //TODO: uncomment next line
//                        self.loginManager.logOut()
                        self.dismissLoadingView()
                        
                        //TODO: Delete This Line
                        self.proceed(with: false)
                    }
                }
            } else {
                self.loginManager.logOut()
                self.dismissLoadingView()
            }
            
            if let error = error {
                print("Error: ", error)
            }
            
            guard let data = data else { print("no data return"); return }
            
            do {
                guard let receivedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { print("nil return from server"); return }
                completion(receivedData)
                
//                guard let status = receivedData["status"] as? Bool else { print("nil return"); return }
//
//                DispatchQueue.main.async {
//                    if Thread.isMainThread {
//                        print("Thread is main")
//                        //MARK: Proceed to next VC
//                        self.proceed(with: status)
//                    }
//                }
            } catch let jsonError {
                print("Failed to decode json: ", jsonError)
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

            // Renove loading view
            dismissLoadingView()
        }
            //If user has no account with us, finish register
        else {
            print("User Not Exist")
            dismissLoadingView()
            performSegue(withIdentifier: "goToAgeSelectionVC", sender: self)
        }
    }
    
    
    //MARK: Remove loading view
    func dismissLoadingView() {
        self.loadingView.alpha = 0
        SVProgressHUD.dismiss()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAgeSelectionVC" {
            let ageViewController = segue.destination as! SelectAgeViewController
            
            ageViewController.userInfo.emailAddress = self.emailFB
            ageViewController.userInfo.facebookID = self.idFB
            ageViewController.userInfo.firstName = self.firstNameFB
            ageViewController.userInfo.lastName = self.lastNameFB
        }
    }
}


extension SignUpInitialVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        if textField == firstNameTextField {
            if let firstName = firstNameTextField.text {
                self.firstName = firstName
                print("First Name: ", firstName)
            }
        }
    }
    
    // return key go to next textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}


// Dismiss Keyboard when scrolling
extension SignUpInitialVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}



