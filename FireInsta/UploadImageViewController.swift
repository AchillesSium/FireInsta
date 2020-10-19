//
//  UploadImageViewController.swift
//  FireInsta
//
//  Created by Sium on 8/21/17.
//  Copyright © 2017 Refat. All rights reserved.
//

import UIKit
import Firebase

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var selectBtnOutlet: UIButton!

    @IBOutlet weak var postBtnOutlet: UIButton!
    
    
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        postBtnOutlet.isHidden = true
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectBtnOutlet.isHidden = true
            postBtnOutlet.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func selectBtnAction(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated:  true, completion: nil)
    }
    
    
    @IBAction func postBtnAction(_ sender: Any) {
        
        AppDelegate.instance().showAcivityIndicator()
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://fireinsta-97ac0.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
            }
            
            imageRef.downloadURL(completion: { (url, err) in
                if let url = url {
                    let feed = ["userID" : uid, "pathToImage" : url.absoluteString, "likes" : 0, "author" : Auth.auth().currentUser!.displayName!, "postID" : key] as [String : Any]
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        uploadTask.resume()
    }
    
}
