//
//  UIImageView+blur.swift
//  BBC 6Music
//
//  Created by Frederic Font Corbera on 21/01/2017.
//  Copyright © 2017 Frederic Font Corbera. All rights reserved.
//
// Taken from: http://stackoverflow.com/questions/30953201/adding-blur-effect-to-background-in-swift

import Foundation
import UIKit

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
