//
//  LoginViewController.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 04/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.red
    }
    
    @IBAction func login() {
        let todoEndpoint: String = "https://reqres.in/api/login"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: url)
        todosUrlRequest.httpMethod = "POST"
        let newTodo: [String: Any] = ["email": self.emailTextField.text!, "password": self.passwordTextField.text!]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: todosUrlRequest) { [weak self]
            (data, response, error) in
            guard error == nil else {
                self?.errorLabel.isHidden = false
                self?.errorLabel.text = error?.localizedDescription
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard (try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any]) != nil else {
                        print("error trying to convert data to JSON")
                        return
                }
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "OpenProfileFromLogin", sender: nil)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

