//
//  RoundedButton.swift
//  Recollection
//
//  Created by Samuel Cole Morgan on 4/16/18.
//  Copyright © 2018 Samuel Cole Morgan. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderThickness: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return UIColor.black
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
}
