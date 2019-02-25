//
//  SignInAndUpHomeViewController.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-31.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

struct HomePage {
    let imageName: String
}

class SignInAndUpHomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = homePages.count
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = .gray
        return pc
    }()
    
    let homePages = [HomePage(imageName: "Icons/build muscle"),
                     HomePage(imageName: "Icons/build muscle"),
                     HomePage(imageName: "Icons/build muscle")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide Nav bar border
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Register customize cell
        collectionView.register(SignInSignUpPageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        
//        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//        statusBar.backgroundColor = .clear
        
        setUpButtonControls()
    }
    
    @objc func handleSignUp() {
//        let nextIndex = min(pageControl.currentPage + 1, homePages.count - 1)
        performSegue(withIdentifier: "goToSignUpPage", sender: self)
    }
    
    fileprivate func setUpButtonControls() {
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl, signUpButton, signInButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.axis = .vertical
        
        self.view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
//        print(x, view.frame.width, x / view.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homePages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SignInSignUpPageCell
//        cell.backgroundColor = indexPath.row % 2 == 0 ? .red : .green
        
        let homePage = homePages[indexPath.row]
        cell.homePage = homePage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
