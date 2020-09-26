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
    
    @IBOutlet var collection: UICollectionView!
    @IBOutlet weak var newMeme: UIBarButtonItem!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collection.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.imageViewCell?.image = meme.memedImage
        
        return cell
    }
    
    @IBAction func newMemePage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController!.present(nextViewController, animated:true, completion: nil)
    }
}
