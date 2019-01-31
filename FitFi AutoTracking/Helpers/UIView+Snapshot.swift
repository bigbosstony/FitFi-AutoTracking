//
//  File.swift
//  FitFi AutoTracking
//
//  Created by YAN YU on 2019-01-30.
//  Copyright © 2019 YAN YU. All rights reserved.
//

import UIKit

extension UIView  {
    
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
