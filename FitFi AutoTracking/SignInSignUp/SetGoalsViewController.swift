//
//  SetGoalsViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-17.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

struct MuscleGroup {
    var name: String
    var select: Bool
}

class SetGoalsViewController: UIViewController {
    
    let muscleGroupStringArray: [String] = ["Tricep", "Bicep", "Forearm", "Chest", "Shoulders", "Back", "Abs", "Glutes", "Thigh", "Calf"]

    let interestStirngArray: [String] = ["2", "3", "4", "5", "6", "7", "8", "8"]
    
    // Construct muscle group array
    lazy var muscleGroupArray: [MuscleGroup] = {
        var muscles = [MuscleGroup]()
        for muscle in muscleGroupStringArray {
            muscles.append(MuscleGroup(name: muscle, select: false))
        }
        return muscles
    }()
    
    var userInfo = userAccountInfoFacebook() {
        didSet {
            print("Goals VC: " ,userInfo)
        }
    }
    
    private var buttonTag: Int = 0 {
        didSet {
            popUpTableView.reloadData()
        }
    }
    
    //Views and Button
    let popUpTableView = UITableView()
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    lazy var topViewOfPopUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var selectMuscleGroupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpTableView.delegate = self
        popUpTableView.dataSource = self
        
        popUpTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func selectMuscleGroupButtonTapped(_ sender: UIButton) {
        handleTableView(from: sender)
    }
    
    @IBAction func selectInterestButtonTapped(_ sender: UIButton) {
        handleTableView(from: sender)
    }
    
//    func changeBuildMuscleButton(with color: UIColor, and image: UIImage) {
//
//    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSelectInterestVC", sender: self)
    }
}

extension SetGoalsViewController {
    
    func handleTableView(from sender: UIButton) {
        buttonTag = sender.tag
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.frame = window.frame
            popUpTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height / 3 * 2)
            topViewOfPopUpView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 50)
            
            topViewOfPopUpView.addSubview(doneButton)
            doneButton.centerYAnchor.constraint(equalTo: topViewOfPopUpView.centerYAnchor).isActive = true
            doneButton.trailingAnchor.constraint(equalTo: topViewOfPopUpView.trailingAnchor, constant: -20).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
            window.addSubview(blackView)
            window.addSubview(topViewOfPopUpView)
            window.addSubview(popUpTableView)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.topViewOfPopUpView.frame = CGRect(x: 0, y: window.frame.height / 3 - 50, width: window.frame.width, height: 50)
                self.popUpTableView.frame = CGRect(x: 0, y: window.frame.height / 3, width: window.frame.width, height: window.frame.height / 3 * 2)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        print("Dismiss")
        
        UIView.animate(withDuration: 0.4) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.popUpTableView.frame = CGRect(x: 0, y: window.frame.height, width: self.popUpTableView.frame.width, height: self.popUpTableView.frame.height)
                self.topViewOfPopUpView.frame = CGRect(x: 0, y: window.frame.height, width: self.topViewOfPopUpView.frame.width, height: self.topViewOfPopUpView.frame.height)
            }
            self.view.willRemoveSubview(self.topViewOfPopUpView)
            self.view.willRemoveSubview(self.popUpTableView)
        }
    }
}

//tableView functions
extension SetGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch buttonTag {
        case 0:
            return muscleGroupArray.count
        default:
            return interestStirngArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        switch buttonTag {
        case 0:
            cell?.textLabel?.text = muscleGroupArray[indexPath.row].name
            cell?.accessoryType = !muscleGroupArray[indexPath.row].select ? .none : .checkmark
        default:
            cell?.textLabel?.text = interestStirngArray[indexPath.row]
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch buttonTag {
        case 0:
            muscleGroupArray[indexPath.row].select = !muscleGroupArray[indexPath.row].select
            print(muscleGroupArray)
        default:
            print(interestStirngArray[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

extension SetGoalsViewController {
    //check user selections
    func gatherUserData() {
        
    }
    
    //sent data to server

}





//        if scrollView.contentOffset.y <= 0 {
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//        }

//    var selectedMuscleGroupArray: [Muscle] = [] {
//        didSet {
//            let hasSelected = selectedMuscleGroupArray.contains { $0.select == true }
//            if hasSelected {
//                print("lol")
//            } else {
//                print("no lol")
//            }
//        }
//    }

//extension SetGoalsViewController: MuscleGroupRecieved {
//
//    func setMuscleGroup(from data: [Muscle]) {
//        selectedMuscleGroupArray = data
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToMuscleGroupVC" {
//            let destinationVC = segue.destination as! MuscleGroupViewController
//            destinationVC.selectedMuscleGroupArray = selectedMuscleGroupArray
//
//            destinationVC.delegate = self
//
//            destinationVC.backingImage = view.makeSnapshot()
//
//        } else if segue.identifier == "goToSelectInterestVC" {
//            let destinationVC = segue.destination as! SelectInterestViewController
//            destinationVC.selectedMuscleGroupArray = selectedMuscleGroupArray
//            destinationVC.userInfo = userInfo
//        }
//    }
//}
