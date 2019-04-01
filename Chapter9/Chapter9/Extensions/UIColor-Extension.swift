//
//  UIColor-Extension.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//
import UIKit
import Foundation

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }

    static let checkInColor = UIColor(red: 0, green: 255, blue: 0)
    static let undoCheckInColor = UIColor(red: 5, green: 10, blue: 0)
    static let deleteColor = UIColor(red: 80, green: 0, blue: 0)
    static let shareColor = UIColor(red: 255, green: 0, blue: 38)
    static let customColor = UIColor(red: 231, green: 76, blue: 60)
}
