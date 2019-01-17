//
//  File.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-17.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class PickerViewLauncher: NSObject {
    
    
    let blackView = UIView()

    let pickerView = UIPickerView()
    
    let ageArray: [String] = ["1", "2", "3", "4", "5"]

    
    func handlePickerView(from row: Int) {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(pickerView)
            
            let height: CGFloat = 200
            let x: CGFloat = 0
            let y = window.frame.height - 200
            let width = window.frame.width
            
            pickerView.frame = CGRect(x: x, y: window.frame.height, width: width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.pickerView.frame = CGRect(x: x, y: y, width: width, height: height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.pickerView.frame = CGRect(x: 0, y: window.frame.height, width: self.pickerView.frame.width, height: self.pickerView.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.black
        
    }
}

extension PickerViewLauncher: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = ageArray[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(ageArray[row])
    }
    
}
