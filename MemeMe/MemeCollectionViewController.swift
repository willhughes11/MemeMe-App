//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by William K Hughes on 9/22/20.
//  Copyright © 2020 William K Hughes. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var newMeme: UIBarButtonItem!
    
    @IBAction func newMemePage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController!.present(nextViewController, animated:true, completion: nil)
    }
}
