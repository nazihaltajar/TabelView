//
//  AboutTableViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    var sectionTitles = ["Feedback", "Follow Us"]
    var sectionContent = [[(image: "store", text: "About.sectionContent01.text".localized, link: "https://www.apple.com/itunes/charts/paid-apps/"),
        (image: "chat", text: "About.sectionContent02.text".localized, link: "http://www.appcoda.com/contact")],
        [(image: "twitter", text: "About.sectionContent03.text".localized, link: "https://twitter.com/appcodamobile"),
        (image: "facebook", text: "About.sectionContent04.text".localized, link: "https://facebook.com/appcodamobile"),
        (image: "instagram", text: "About.sectionContent05.text".localized, link: "https://www.instagram.com/appcodadotcom")]]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        customizeNavigationBar()
    }

    private func customizeNavigationBar() {
        navigationController?.setNavigationBarBackgroundImageTransparent()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
                UIColor.navBarColor, NSAttributedString.Key.font: customFont ]
        }
        tableView.tableFooterView = UIView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            if let destinationController = segue.destination as? WebViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                destinationController.targetURL = sectionContent[indexPath.section][indexPath.row].link
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
        let cellData = sectionContent[indexPath.section][indexPath.row]

        cell.textLabel?.text = cellData.text
        cell.imageView?.image = UIImage(named: cellData.image)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = sectionContent[indexPath.section][indexPath.row].link
        guard let url = URL(string: link) else { return }

        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                    UIApplication.shared.open(url)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "showWebView", sender: self)
            }
        case 1:
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
