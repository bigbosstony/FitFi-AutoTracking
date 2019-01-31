//
//  MuscleGroupCollectionViewCell.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-29.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

class MuscleGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    //Setup for customize cell
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
}
