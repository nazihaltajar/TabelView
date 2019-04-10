//
//  RoundedTextFiled.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 08/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RoundedTextFiled: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
