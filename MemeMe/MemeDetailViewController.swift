//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by William K Hughes on 9/28/20.
//  Copyright © 2020 William K Hughes. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        imageView.image = meme.memedImage
    }    
}
