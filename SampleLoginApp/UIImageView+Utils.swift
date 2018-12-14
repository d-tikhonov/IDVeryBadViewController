//
//  UIImageView+Utils.swift
//  SampleLoginApp
//
//  Created by Dmitry Tetenyuk on 14/12/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageFrom(url:URL, withPlaceHolderImage placeholer:UIImage? = nil) {
        self.image = placeholer
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self?.image = UIImage(data: data)
            }
        }
        dataTask.resume()
    }
}
