//
//  RegisterViewController.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 04/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, RegisterDataProviderOutput {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var dataProvider: RegisterDataProviderInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.red
        dataProvider = RegisterDataProvider(output: self)
    }
    
    @IBAction func register() {
        dataProvider?.register(login: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    func registrationFinished(error: Error?) {
        DispatchQueue.main.async {
            guard error == nil else {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Что то пошло не так"
                return
            }
            self.performSegue(withIdentifier: "OpenProfileFromLogin", sender: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
