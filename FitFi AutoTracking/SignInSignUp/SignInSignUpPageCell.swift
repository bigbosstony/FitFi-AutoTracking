//
//  SignInSignUpPageCell.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-02-22.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit


class SignInSignUpPageCell: UICollectionViewCell {
    
    var homePage: HomePage? {
        didSet {
            guard let unwrappedHomePage = homePage else { return }
            imageView.image = UIImage(named: unwrappedHomePage.imageName)
        }
    }
    
    //set variable in closure
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        // enable autolayout for imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let imageContainerView = UIView()
        addSubview(imageContainerView)
        
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true


        
        imageContainerView.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 1).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1).isActive = true
        
        imageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
    }
}
