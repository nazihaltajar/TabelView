//
//  WalkthroughPageViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 18/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {
    var pageHeadings = ["WalkPage.headings01".localized, "WalkPage.headings02".localized, "WalkPage.headings03".localized]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = ["WalkPage.subheadings01".localized,
                           "WalkPage.subheadings02".localized,
                           "WalkPage.subheadings03".localized]
    var currentIndex = 0
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers( [startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let walkthroughViewController = viewController as? WalkthroughContentViewController else { return UIViewController()}
        var index = walkthroughViewController.index
        index -= 1

        return contentViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let walkthroughViewController = viewController as? WalkthroughContentViewController else { return UIViewController()}
        var index = walkthroughViewController.index
        index += 1

        return contentViewController(at: index)
    }

    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }

    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
        pageContentViewController.imageFile = pageImages[index]
        pageContentViewController.heading = pageHeadings[index]
        pageContentViewController.subheading = pageSubHeadings[index]
        pageContentViewController.index = index

        return pageContentViewController
    }
        return nil
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
}
