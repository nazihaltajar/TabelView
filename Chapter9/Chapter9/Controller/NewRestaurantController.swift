//
//  NewRestaurantController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 08/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class NewRestaurantController: UITableViewController, UINavigationControllerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: RoundedTextFiled! {
        didSet {
            nameTextField.tag  = 1
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var typeTextField: RoundedTextFiled! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    @IBOutlet weak var addressTextField: RoundedTextFiled! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneTextField: RoundedTextFiled! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setBackButtonTintColor(mycolor: .white)
        customizationNavigationBar()
    }

    public func customizationNavigationBar() {
        navigationController?.setNavigationBarBackgroundImageTransparent()
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.customColor,
                NSAttributedString.Key.font: customFont]
        }
    }
}

extension NewRestaurantController: UITextFieldDelegate {

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextTextFiled = view.viewWithTag(textField.tag + 1) {
        textField.resignFirstResponder()
        nextTextFiled.becomeFirstResponder()
    }
    return true
    }
}

extension NewRestaurantController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .alert)
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera

                    self.present(imagePicker, animated: true, completion: nil)
                }
            })

            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (_) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary

                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)

            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                    popoverController.permittedArrowDirections = .any
                }
            }
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
}

extension NewRestaurantController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
     if let selectedImage = info[ UIImagePickerController.InfoKey.originalImage ] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleToFill
            photoImageView.clipsToBounds = true
        }
        let leadingContraint = NSLayoutConstraint(item: photoImageView ?? "", attribute: .leading, relatedBy: .equal,
                                                  toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingContraint.isActive = true

        let trailingConstraint = NSLayoutConstraint(item: photoImageView ?? "", attribute: .trailing, relatedBy: .equal,
                                                  toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true

        let topConstraint = NSLayoutConstraint(item: photoImageView ?? "", attribute: .top, relatedBy: .equal,
                                                  toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true

        let bottomConstraint = NSLayoutConstraint(item: photoImageView ?? "", attribute: .bottom, relatedBy: .equal,
                                               toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true

        dismiss(animated: true, completion: nil)
    }
}
