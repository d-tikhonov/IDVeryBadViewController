//
//  RegisterViewController.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 04/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.red
    }
    
    @IBAction func register() {
        let apiObject = APIObject(url: APIURL.register,
                                  method: .post,
                                  parameters: ["email": self.emailTextField.text!, "password": self.passwordTextField.text!])
        
        NetWorker.shared.requestWithAPIObject(apiObject) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                    self?.errorLabel.text = "Что то пошло не так"
                }
                return
            }
            do {
                guard (try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any]) != nil else {
                        print("error trying to convert data to JSON")
                        DispatchQueue.main.async {
                            self?.errorLabel.isHidden = false
                            self?.errorLabel.text = "Что то пошло не так"
                        }
                        return
                }
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "OpenProfileFromLogin", sender: nil)
                }
            } catch  {
                print("error trying to convert data to JSON")
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                    self?.errorLabel.text = "Что то пошло не так"
                }
                return
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

