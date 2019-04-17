//
//  WalkthroughContentViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 17/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UITableViewController {
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

    var index = 0
    var heading = ""
    var subheading = ""
    var imageFile = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subHeadingLabel.text = subheading
        contentImageView.image = UIImage(named: imageFile)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
