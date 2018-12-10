//
//  ProfileViewController.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 04/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    private func loadAvatar(url:URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self?.avatarImageView.image = UIImage(data: data)
            }
        }
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let todoEndpoint: String = "https://reqres.in/api/users/1"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let todosUrlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: todosUrlRequest) {
            [weak self]
            (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let dict = try JSONSerialization.jsonObject(with: responseData, options: [])
                as? [String: [String:Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                let truedict = dict["data"]!
                DispatchQueue.main.async {
                    self?.nameLabel.text = truedict["first_name"] as? String
                    self?.secondNameLabel.text = truedict["last_name"] as? String
                    if let avatarURL = URL(string: truedict["avatar"] as? String ?? "") {
                        self?.loadAvatar(url: avatarURL)
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}
