//
//  SignUpViewController.swift
//  FireInsta
//
//  Created by Sium on 8/18/17.
//  Copyright © 2017 Refat. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    @IBOutlet weak var signUpImage: UIImageView!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
        let storage = Storage.storage().reference(forURL: "gs://fireinsta-97ac0.appspot.com")
        ref = Database.database().reference()
        userStorage = storage.child("users")
        
        
        
    }

    @IBAction func selectImageAction(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.signUpImage.image = image
            nextButtonOutlet.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard nameText.text != "", emailText.text != "", passwordText.text != "", confirmPasswordText.text != "" else {
            return
        }
        
        if passwordText.text == confirmPasswordText.text {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                print("1")
                if let error = error {
                    print(error.localizedDescription)
                    print("2")
                }
                if let user = user {
                    print("3")
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.nameText.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.signUpImage.image!, 0.5)
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                            print("4")
                        }
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                                print("5")
                            }
                            if let url = url {
                                print("6")
                                let userInfo: [String : Any] = ["uid" : user.uid, "full name" : self.nameText.text!, "urlToImage" : url.absoluteString]
                                
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "userVC")
                                self.present(controller, animated: true, completion: nil)
                            }
                            print("7")
                        })
                        print("8")
                    })
                    uploadTask.resume()
                }
                print("9")
            })
        } else {
            print("10")
        }
    }
    
    
   
}
