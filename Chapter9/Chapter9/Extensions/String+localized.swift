//
//  String+localized.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 23/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
