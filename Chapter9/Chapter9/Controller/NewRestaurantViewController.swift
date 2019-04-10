//
//  NewRestaurantController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 08/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class NewRestaurantViewController: UITableViewController, UINavigationControllerDelegate {
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var nameTextField: RoundedTextFiled! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak private var typeTextField: RoundedTextFiled! {
        didSet {
            typeTextField.delegate = self
        }
    }
    @IBOutlet weak var addressTextField: RoundedTextFiled! {
        didSet {
            addressTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneTextField: RoundedTextFiled! {
        didSet {
            phoneTextField.delegate = self
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    @IBAction func saveButtonTapped() {
        if checkIfTextFieldsAreEmpty() {
            dismiss(animated: true, completion: nil)
        } else {
            let alertMessage = UIAlertController(title: "Ooops",
            message: "We can't proceed because one of the fields is blank. Please note that all fields are required.",
            preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setBackButtonTintColor(mycolor: .white)
        customizationNavigationBar()
    }

    func checkIfTextFieldsAreEmpty () -> Bool {
        guard let name = nameTextField.text, !name.isEmpty  else {
            return false
        }
        guard let type = typeTextField.text, !type.isEmpty else {
            return false
        }
        guard let address = addressTextField.text, !address.isEmpty else {
            return false
        }
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            return false
        }
        guard let description = descriptionTextView.text, !description.isEmpty else {
            return false
        }
        print (name)
        print (type)
        print (address)
        print (phone)
        print (description)

        return true
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

extension NewRestaurantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextFiled = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextFiled.becomeFirstResponder()
        }
        return true
    }
}

extension NewRestaurantViewController {
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
                }
            }
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
}

extension NewRestaurantViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[ UIImagePickerController.InfoKey.originalImage ] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleToFill
            photoImageView.clipsToBounds = true
        }
        NSLayoutConstraint(item: photoImageView ?? "", attribute: .leading, relatedBy: .equal,
                                                  toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: photoImageView ?? "", attribute: .trailing, relatedBy: .equal,
                                                    toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: photoImageView ?? "", attribute: .top, relatedBy: .equal,
                                               toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: photoImageView ?? "", attribute: .bottom, relatedBy: .equal,
                                                  toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        dismiss(animated: true, completion: nil)
    }
}
