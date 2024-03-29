//
//  FinishProfileSetupVC.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-17.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class ProfileDetailsSetupVC: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    //    var fieldArray: [String: Any?] = ["Age": nil, "Weight": nil, "Height": nil]
    
    let fieldNameArray: [String] = ["Age", "Weight", "Height"]
    
    let weightUnitArray: [String] = ["KG", "LBS"]
    
    let heightUnitArray: [String] = ["cm", "inch"]
    
    var currentWeightUnit = 0
    
    var currentHeightUnit = 0
    
    var goNext = false
    
    var userAgeWeightHeightArray: [Any?] = [nil, nil, nil] {
        didSet {
            let next = userAgeWeightHeightArray.contains { $0 == nil }
            if !next {
                goNext = true
                nextButton.backgroundColor = UIColor.init(red: 246/255, green: 120/255, blue: 12/255, alpha: 1)
            }
        }
    }
    
    
    let ageStringArray: [String] = {
        let ageArray = Array(0...120)
        return ageArray.map{ String($0) }
    }()
    
    let weightStringArray: [String] = {
        let weightArray: [Int] = Array(0...500)
        return weightArray.map{ String($0) }
    }()
    
    let heightStringArray: [String] = {
        let heightArray: [Int] = Array(0...400)
        return heightArray.map{ String($0) }
    }()
    
    var userInfo = userAccountInfoFacebook() {
        didSet {
            print("FinishProfileSetupVC", userInfo)
        }
    }
    
    var key: Int = 0 {
        didSet {
            pickerView.reloadAllComponents()

            if let number = userAgeWeightHeightArray[key] as? String {
                print(number)
                pickerView.selectRow(Int(number)!, inComponent: 0, animated: false)
            } else {
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            
            if key == 1 {
                pickerView.selectRow(currentWeightUnit, inComponent: 1, animated: false)
            } else if key == 2 {
                pickerView.selectRow(currentHeightUnit, inComponent: 1, animated: false)
            }
        }
    }

    @IBOutlet weak var profileSetupTableView: UITableView!
    
    
    let blackView = UIView()
    let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        profileSetupTableView.delegate = self
        profileSetupTableView.dataSource = self
        
        profileSetupTableView.tableFooterView = UIView()
        profileSetupTableView.rowHeight = 44
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.black
        
//        self.navigationItem.hidesBackButton = true
        
        nextButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if goNext {
            performSegue(withIdentifier: "goToSetGoalsVC", sender: self)
        } else {
            sender.shake()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSetGoalsVC" {
            let destinationVC = segue.destination as! SetGoalsViewController
            print("perform Segue")
            destinationVC.userInfo = userInfo
        }
    }
    
    func handlePickerView(from row: Int) {
        
        key = row
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            let x: CGFloat = 0
            let height: CGFloat = window.frame.height / 3 - 44

            let y = window.frame.height - height
            let width = window.frame.width
            
            pickerView.frame = CGRect(x: x, y: window.frame.height, width: width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            toolBar.sizeToFit()
            toolBar.frame = CGRect(x: x, y: window.frame.height, width: width, height: 44)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDismiss))
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let fixButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            fixButton.width = 20.0
            
            toolBar.setItems([flexButton, doneButton, fixButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            toolBar.barTintColor = .black
            toolBar.tintColor = .white
            
            window.addSubview(blackView)
            window.addSubview(pickerView)
            window.addSubview(toolBar)
            
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.pickerView.frame = CGRect(x: x, y: y, width: width, height: height)
                self.toolBar.frame = CGRect(x: 0, y: y - 44, width: width, height: 44)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.pickerView.frame = CGRect(x: 0, y: window.frame.height, width: self.pickerView.frame.width, height: self.pickerView.frame.height)
                self.toolBar.frame = CGRect(x: 0, y: window.frame.height, width: self.toolBar.frame.width, height: self.toolBar.frame.height)
            }
            self.view.willRemoveSubview(self.pickerView)
            self.view.willRemoveSubview(self.toolBar)
        }
        
    }
}

extension ProfileDetailsSetupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSetupTableViewCell", for: indexPath) as! ProfileSetupTableViewCell
//        let fieldKeyArray = Array(fieldData.keys)
        
        cell.textLabel?.text = fieldNameArray[indexPath.row]
        if indexPath.row == 1 {
            var string = userAgeWeightHeightArray[1] as? String ?? ""
            string.append(" " + weightUnitArray[currentWeightUnit])
            cell.cellLabel.text = string
        } else if indexPath.row == 2 {
            var string = userAgeWeightHeightArray[2] as? String ?? ""
            string.append(" " + heightUnitArray[currentHeightUnit])
            cell.cellLabel.text = string
        } else {
            cell.cellLabel.text = userAgeWeightHeightArray[0] as? String ?? ""
        }
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        cell.profileSetupTextField.inputView = pickerView

        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handlePickerView(from: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileDetailsSetupVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if key == 0 {
            return 1
        } else if key == 1 {
            return 2
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if key == 0 {
            return ageStringArray.count
        } else if key == 1 {
            if component == 0 {
                return weightStringArray.count
            } else {
                return weightUnitArray.count
            }
        } else {
            if component == 0 {
                return heightStringArray.count
            } else {
                return heightUnitArray.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if key == 0 {
            let string = ageStringArray[row]
            return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else if key == 1 {
            if component == 0 {
                let string = weightStringArray[row]
                return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            } else {
                let string = weightUnitArray[row]
                return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        } else {
            if component == 0 {
                let string = heightStringArray[row]
                return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            } else {
                let string = heightUnitArray[row]
                return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if key == 0 {
            userAgeWeightHeightArray[key] = ageStringArray[row]
            userInfo.age = Int(ageStringArray[row])
        } else if key == 1 {
            if component == 0 {
                userAgeWeightHeightArray[key] = weightStringArray[row]
                userInfo.weight = Int(weightStringArray[row])
            } else {
                userInfo.weightUnit = weightUnitArray[row]
                currentWeightUnit = row
            }
        } else {
            if component == 0 {
                userAgeWeightHeightArray[key] = heightStringArray[row]
                userInfo.height = Int(heightStringArray[row])
            } else {
                userInfo.heightUnit = heightUnitArray[row]
                currentHeightUnit = row
            }
        }
        profileSetupTableView.reloadData()
        
        
        print(userAgeWeightHeightArray)
    }
}
