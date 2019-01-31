//
//  SetGoalsViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-17.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class SetGoalsViewController: UIViewController {
    
    let muscleStirngArray: [String] = ["Tricep", "Bicep", "Forearm", "Chest", "Shoulders", "Back", "Abs", "Glutes", "Thigh", "Calf"]

    var selectedMuscleGroupArray: [Muscle] = [] {
        didSet {
            let hasSelected = selectedMuscleGroupArray.contains { $0.select == true }
            if hasSelected {
                print("lol")
            } else {
                print("no lol")
            }
        }
    }
    
    var userInfo = userAccountInfoFacebook() {
        didSet {
            print("Goals VC: " ,userInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("From View will appear", userInfo)
        
        print(selectedMuscleGroupArray.isEmpty)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let width = self.view.frame.width - 40
        let y = (self.view.frame.maxY - 60) / 2
        
        let buildMuscleButton: BounceButton = BounceButton(type: .custom)
        buildMuscleButton.backgroundColor = .red
        buildMuscleButton.tintColor = .white
        buildMuscleButton.frame = CGRect(x: 20, y: y, width: width, height: 60)
        buildMuscleButton.setImage(UIImage(named: "Icons/build muscle"), for: .normal)
        buildMuscleButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: width - 95)
        buildMuscleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        buildMuscleButton.setTitle("Build Muscle", for: .normal)
        buildMuscleButton.layer.cornerRadius = 5
        
        buildMuscleButton.addTarget(self, action: #selector(showMuscleGroupView), for: .touchUpInside)
        
        self.view.addSubview(buildMuscleButton)
        
        // Construct muscle group array
        for part in muscleStirngArray {
            selectedMuscleGroupArray.append(Muscle(name: part, select: false))
        }
        
//        self.navigationItem.hidesBackButton = true
    }
    
    @objc func showMuscleGroupView() {
        performSegue(withIdentifier: "goToMuscleGroupVC", sender: self)
    }
    
    func changeBuildMuscleButton(with color: UIColor, and image: UIImage) {
        
    }
    
    @IBAction func nexButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSelectInterestVC", sender: self)
    }
    
}

extension SetGoalsViewController: MuscleGroupRecieved {
    
    func setMuscleGroup(from data: [Muscle]) {
        selectedMuscleGroupArray = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMuscleGroupVC" {
            let destinationVC = segue.destination as! MuscleGroupViewController
            destinationVC.selectedMuscleGroupArray = selectedMuscleGroupArray
            
            destinationVC.delegate = self
            
            destinationVC.backingImage = view.makeSnapshot()
            
        } else if segue.identifier == "goToSelectInterestVC" {
            let destinationVC = segue.destination as! SelectInterestViewController
            destinationVC.selectedMuscleGroupArray = selectedMuscleGroupArray
            destinationVC.userInfo = userInfo
        }
    }
}
