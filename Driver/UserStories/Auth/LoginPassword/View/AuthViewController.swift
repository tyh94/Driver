//
//  AuthViewController.swift
//  Driver
//
//  Created by Татьяна Хохлова on 22/08/2019.
//  Copyright © 2019 Iway. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var restorePasswordButton: UIButton!

    var viewOutput: AuthViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureKeyboard()
        continueButton.layer.cornerRadius = 4
        continueButton.layer.borderColor = UIColor(named: "titleTextColor")?.cgColor
        continueButton.layer.borderWidth = 2
        restorePasswordButton.layer.cornerRadius = 4
        restorePasswordButton.layer.borderColor = UIColor(named: "titleTextColor")?.cgColor
        restorePasswordButton.layer.borderWidth = 2
    }

    @IBAction func continueAction(_ sender: UIButton) {
        guard let phone = phoneTextField.text,
            let password = passwordTextField.text else {
                return
        }
        sender.startAnimating()
        viewOutput.login(phone: phone, password: password)
    }

    @IBAction func recoverPasswordAction(_ sender: UIButton) {
        viewOutput.needRestorePassword(login: phoneTextField.text)
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard(sender:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func configureKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (notification) in
                                                guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
                                                    let scrollView = self?.scrollView,
                                                    let continueButton = self?.continueButton,
                                                    let buttonFrame = continueButton.superview?.convert(continueButton.frame,
                                                                                                        to: scrollView) else { return }
                                                let buttonOffset = scrollView.frame.size.height - buttonFrame.origin.y - buttonFrame.size.height
                                                scrollView.contentOffset.y = max(0, keyboardSize.height - buttonOffset + 24)
                                                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (notification) in
                                                self?.scrollView.contentOffset = .zero
                                                self?.scrollView.contentInset = .zero

        }
    }

}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        continueButton.isEnabled = !(passwordTextField.text?.isEmpty ?? true) &&
            !(phoneTextField.text?.isEmpty ?? true)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            continueAction(continueButton)
        }
        return true
    }

}

// MARK: - UIGestureRecognizerDelegate

extension AuthViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            return !(touch.view is UIButton)
        }
        return true
    }

}

// MARK: - AuthViewInput

extension AuthViewController: AuthViewInput {

    func stopLoading() {
        continueButton.stopAnimating()
    }

}
