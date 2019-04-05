//
//  ReviewViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 04/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//
import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!

    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBlurEffect()
        setTransformActions()
    }

    private func setTransformActions () {
        let moveRightTransform = CGAffineTransform(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        let moveFromUpDownTransform = CGAffineTransform(translationX: 0, y: -200)

        closeButton.transform = moveFromUpDownTransform
        closeButton.alpha = 0

        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 2.0) {
            self.closeButton.alpha = 1.0
            self.closeButton.transform = .identity
        }

        UIView.animate(withDuration: 2.0) {
            var delays = 0.1
            var damping = 0.2
            var velocity = 0.3

            for index in 0...4 {
                UIView.animate(withDuration: 0.2, delay: delays + 0.3, usingSpringWithDamping: CGFloat(damping + 0.3), initialSpringVelocity: CGFloat(velocity + 0.3),
                               options: [], animations: {
                                self.rateButtons[index].alpha = 1.0
                                self.rateButtons[index].transform = .identity
                }, completion: nil)
                delays += 0.5
                damping -= 0.15
                velocity -= 0.3
            }
        }
    }

    private func setUpBlurEffect() {
        backgroundImageView.image = UIImage(named: restaurant.image)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
    }
}
