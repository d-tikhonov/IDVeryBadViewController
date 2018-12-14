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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiObject = APIObject(url: APIURL.profile,
                                  method: .get,
                                  parameters: nil)
        
        NetWorker.shared.requestWithAPIObject(apiObject) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                guard let data = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: [String:Any]] else {
                        return
                }
                let truedict = data["data"]!
                DispatchQueue.main.async {
                    self?.nameLabel.text = truedict["first_name"] as? String
                    self?.secondNameLabel.text = truedict["last_name"] as? String
                    if let avatarURL = URL(string: truedict["avatar"] as? String ?? "") {
                        self?.avatarImageView.loadImageFrom(url: avatarURL, withPlaceHolderImage: UIImage(named: "doge"))
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
    }
    
}
