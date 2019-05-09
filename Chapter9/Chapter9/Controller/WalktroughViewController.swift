//
//  WalktroughViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 18/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class WalktroughViewController: UIViewController {
    var walkthroughPageViewController: WalkthroughPageViewController?

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton!
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        createQuickActions()

        dismiss(animated: true, completion: nil)
    }
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0, 1:
                walkthroughPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                createQuickActions()
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
        updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        skipButton.setTitle("WalkView.button2".localized, for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

    private func createQuickActions() {
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavourites",
                        localizedTitle: "Show Favourites",
                        localizedSubtitle: nil,
                        icon: UIApplicationShortcutIcon(templateImageName: "favourite"), userInfo: nil)
                let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover",
                        localizedTitle: "Discover Restaurants",
                        localizedSubtitle: nil,
                        icon: UIApplicationShortcutIcon(templateImageName: "discover"), userInfo: nil)
                let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant",
                        localizedTitle: "New Restaurant",
                        localizedSubtitle: nil,
                        icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
                UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
            }
        }
    }

    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("WalkView.button".localized, for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("WalkView.button1".localized, for: .normal)
                skipButton.isHidden = true
            default:
                break
            }
            pageControl.currentPage = index
        }
    }
}

extension WalktroughViewController: WalkthroughPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
