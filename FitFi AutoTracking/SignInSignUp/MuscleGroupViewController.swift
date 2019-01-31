//
//  MuscleGroupViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-29.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

protocol MuscleGroupRecieved {
    func setMuscleGroup(from data: [Muscle])
}


class MuscleGroupViewController: UIViewController {

    var delegate: MuscleGroupRecieved?
    var selectedMuscleGroupArray: [Muscle]? {
        didSet {
            print(selectedMuscleGroupArray)
            if muscleGroupCollectionView != nil {
                muscleGroupCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var muscleGroupCollectionView: UICollectionView!
    
    var muscleGroupArray: [Muscle] = [Muscle]()
    
    var backingImage: UIImage?
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerLayer: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        muscleGroupCollectionView.dataSource = self
        muscleGroupCollectionView.delegate = self
        // collectionView always scroll
//        self.muscleGroupCollectionView.alwaysBounceVertical = true

        scrollView.delegate = self
        
        muscleGroupCollectionView.layer.cornerRadius = 10
        muscleGroupCollectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        // Setup customize cell size
        if let flowLayout = muscleGroupCollectionView.collectionViewLayout as? UICollectionViewFlowLayout, let collectionView = muscleGroupCollectionView {
            let width = collectionView.frame.width / 2 - 25
            flowLayout.estimatedItemSize = CGSize(width: width, height: 100)
            
            print(collectionView.frame.width)
            print(width)
        }
        
        

        //Get the safe area frame
//        let guide = view.safeAreaLayoutGuide
//        let height = guide.layoutFrame.size.height
//        print("Height: ", height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("did")
        backingImageView.image = backingImage

        animateBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will")
    }
    
    
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        delegate?.setMuscleGroup(from: selectedMuscleGroupArray ?? [Muscle]())
        self.dismiss(animated: true, completion: nil)
    }
}


extension MuscleGroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selectedMuscleGroupArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! MuscleGroupCollectionViewCell
        
        let muscle = selectedMuscleGroupArray?[indexPath.row]
        
        cell.backgroundColor = muscle?.select ?? false ? UIColor.red : UIColor.black
        cell.cellLabel.text = muscle?.name
        cell.cellLabel.textColor = muscle?.select ?? false ? UIColor.yellow : UIColor.white
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.row
        
        selectedMuscleGroupArray![selectedItem].select = !selectedMuscleGroupArray![selectedItem].select
        
        print(indexPath)
    }
}



extension MuscleGroupViewController: UIScrollViewDelegate {
    //Set offsetY for scroll view on bottom to prevent showing the background
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetYToStop: CGFloat!
        let screenHeight = self.view.frame.height
        
        //iphone xs and xs max, bottom padding
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        
        let actualScreenHeight = screenHeight - (bottomPadding ?? 0.0)
        
        let contentHeight = CGFloat(180 + 580 + 128)
        
        
        if contentHeight > actualScreenHeight {
            offsetYToStop = contentHeight - actualScreenHeight
        } else {
            offsetYToStop = actualScreenHeight - contentHeight
        }
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > offsetYToStop {
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetYToStop), animated: false)
        }
    }
}

extension MuscleGroupViewController {
    func animateBackgroundView() {
        UIView.animate(withDuration: 0.7) {
            self.dimmerLayer.alpha = 0.3

        }
    }
}
