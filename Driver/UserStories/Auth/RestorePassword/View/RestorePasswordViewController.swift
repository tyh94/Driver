//
//  RestorePasswordViewController.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class RestorePasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var restoreButton: UIButton!

    var viewOutput: RestorePasswordViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewOutput.moduleWasLoaded()
        restoreButton.layer.cornerRadius = 4
        restoreButton.layer.borderColor = UIColor(named: "titleTextColor")?.cgColor
        restoreButton.layer.borderWidth = 2
    }

    @IBAction func restorePasswordAction(_ sender: UIButton) {
        if let phone = phoneTextField.text,
            !phone.isEmpty {
            viewOutput.restore(phone: phone)
        } else {
            phoneTextField.resignFirstResponder()
        }
    }

}

// MARK: - ResorePasswordViewInput

extension RestorePasswordViewController: RestorePasswordViewInput {

    func update(phone: String) {
        phoneTextField.text = phone
    }

}

// MARK: - UITextFieldDelegate

extension RestorePasswordViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        restoreButton.isEnabled = !(textField.text?.isEmpty ?? true)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restorePasswordAction(restoreButton)
        return true
    }

}
