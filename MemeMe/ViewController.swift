//
//  ViewController.swift
//  MemeMe
//
//  Created by William K Hughes on 9/16/20.
//  Copyright © 2020 William K Hughes. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    // MARK: Variable Declaration
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var memeImage: UIImage!
    
    var topDefaultText: String = "TOP"
    var bottomDefaultText: String = "BOTTOM"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 60)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        
        setupTextField(topTextfield, topDefaultText)
        setupTextField(bottomTextfield, bottomDefaultText)
    }
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: Textfield Functions
    func setupTextField(_ textField: UITextField, _ defaultText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
    }
    @IBAction func topTextfieldEdit(_ sender: UITextField) {
        if (topTextfield.text == topDefaultText){
            topTextfield.text = ""
        }
    }
    
    @IBAction func bottomTextfieldEdit(_ sender: UITextField) {
        if (bottomTextfield.text == bottomDefaultText){
            bottomTextfield.text = ""
        }
    }
    
    @IBAction func topMemeTextFieldShouldReturn(_ sender: Any) {
        topTextfield.resignFirstResponder()
    }
    
    @IBAction func bottomMemeTextFieldShouldReturn(_ sender: Any) {
        bottomTextfield.resignFirstResponder()
    }

    // MARK: Image Functions
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickFromSource(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        pickFromSource(.camera)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Keyboard Notification Functions
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextfield.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextfield.isEditing, view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Meme Generation Functions
    func generateMemedImage() -> UIImage {
        navigationBar.isHidden = true
        toolbar.isHidden = true
            
        navigationController?.setToolbarHidden(true, animated: false)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navigationController?.setToolbarHidden(false, animated: false)
            
        navigationBar.isHidden = false
        toolbar.isHidden = false
            
        return memedImage
    }

    func save() {
        memeImage = generateMemedImage()
        _ = MemeStruct.Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: memeImage!)
        }
    
    @IBAction func saveMeme(){
        let memedImage: UIImage = generateMemedImage()
        let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { (_, completed, _, _) in
            if (completed) {
                self.save()
                }
            }
            present(shareSheet, animated: true, completion: nil)
        }
    
    // MARK: Dismiss Meme Function
    @IBAction func resetToDefault(_ sender: Any) {
        shareButton.isEnabled = false
        topTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.textAlignment = NSTextAlignment.center
        topTextfield.text = topDefaultText
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.textAlignment = NSTextAlignment.center
        bottomTextfield.text = bottomDefaultText
        imagePickerView.image = nil
    }
}
