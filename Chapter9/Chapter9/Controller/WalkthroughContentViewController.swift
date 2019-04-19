//
//  WalkthroughContentViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 17/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    var index = 0
    var heading = ""
    var subheading = ""
    var imageFile = ""

    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
        }
    }
    @IBOutlet var contentImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subHeadingLabel.text = subheading
        contentImageView.image = UIImage(named: imageFile)
    }
}
