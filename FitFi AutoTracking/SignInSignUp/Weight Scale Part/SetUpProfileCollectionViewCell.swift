//
//  SetUpProfileCollectionViewCell.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-16.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class SetUpProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var setUpProfileCellView: UIView!
    @IBOutlet weak var setUpProfileCellView2: UIView!
    
    @IBOutlet weak var setUpProfileCellTableView: UITableView!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    let userInfo : [[String]] = [["Age", "Weight", "Height"]]
    
    var userInfoArray = ["gender" : nil] as [String : Any?] {
        didSet {
            print("Data Set")
            print(userInfoArray)
            for data in userInfoArray {
                if data.value == nil {
                    print("not complete")
                }
            }
        }
    }
    
    var gender: [Bool] = [false, false] {
        didSet {
            if gender[0] {
                maleButton.backgroundColor = UIColor.blue
                maleButton.setTitleColor(UIColor.white, for: .normal)
                femaleButton.backgroundColor = UIColor.white
                femaleButton.setTitleColor(UIColor.blue, for: .normal)
                userInfoArray["gender"] = "male"
            } else {
                femaleButton.backgroundColor = UIColor.blue
                femaleButton.setTitleColor(UIColor.white, for: .normal)
                maleButton.backgroundColor = UIColor.white
                maleButton.setTitleColor(UIColor.blue, for: .normal)
                userInfoArray["gender"] = "female"
            }
        }
    }
    
    @IBOutlet weak var ageTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        
        ageTextField.delegate = self
        ageTextField.selectedTextRange = nil
        ageTextField.tintColor = UIColor.clear
        
        widthConstraint.constant = screenWidth
        heightConstraint.constant = screenHeight - (100 + 44 + 20)
        

        
        setUpProfileCellTableView.tableFooterView = UIView()
        setUpProfileCellTableView.delegate = self
        setUpProfileCellTableView.dataSource = self
    }

    @IBAction func maleButtonTapped(_ sender: UIButton) {
        gender[0] = true
        gender[1] = false
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        gender[1] = true
        gender[0] = false
    }
    
}

extension SetUpProfileCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return "Getting More Info About You"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = userInfo[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor.gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(indexPath)
        
        tableView.reloadData()
    }
}

extension SetUpProfileCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
}

extension SetUpProfileCollectionViewCell: UITextFieldDelegate {
    
}
