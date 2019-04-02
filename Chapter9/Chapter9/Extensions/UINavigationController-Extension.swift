//
//  UINavigationController+Ext.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 01/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    public func setNavigationBarBackgroundImageTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
