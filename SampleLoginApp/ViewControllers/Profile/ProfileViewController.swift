//
//  ProfileViewController.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 04/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileDataProviderOutput {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    private var dataProvider: ProfileDataProviderInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = ProfileDataProvider(output: self)
        dataProvider?.requestUser()
    }
    
    func loadingFinished(user: User?, error: Error?) {
        DispatchQueue.main.async {
            guard let user = user, error == nil else {
                return
            }
            self.nameLabel.text = user.firstName
            self.secondNameLabel.text = user.lastName
            if let avatarURL = URL(string: user.avatarURL) {
                self.avatarImageView.loadImageFrom(url: avatarURL, withPlaceHolderImage: UIImage(named: "doge"))
            }
        }
    }
}
