//
//  SocialDetailsViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-15.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class SocialDetailsViewController: UIViewController {

    @IBOutlet weak var setUpProfileCollectionView: UICollectionView!
    
//    var userInfo = userAccountInfoFacebook() {
//        didSet {
//            let mirror = Mirror(reflecting: userInfo)
//
//            print("User Info Set")
//            print(userInfo)
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide Tab bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //
        setUpProfileCollectionView.register(UINib.init(nibName: "SetUpProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SetUpProfileCollectionViewCell")
        
        let cellWidth = setUpProfileCollectionView.frame.width
        let cellHeight = setUpProfileCollectionView.frame.height
        
        
        if let flowLayout = setUpProfileCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: cellWidth, height: cellHeight)
        }
        
//        print("Height: ", self.navigationController?.navigationBar.frame.height)
        setUpProfileCollectionView.delegate = self
        setUpProfileCollectionView.dataSource = self
        
        setUpProfileCollectionView.isPagingEnabled = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let loginManager = LoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
    
}

extension SocialDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetUpProfileCollectionViewCell", for: indexPath) as! SetUpProfileCollectionViewCell
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetUpProfileCollectionViewCell", for: indexPath) as! SetUpProfileCollectionViewCell
            cell.setUpProfileCellView.isHidden = true
            return cell
        }
    }
    
}

extension SocialDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
