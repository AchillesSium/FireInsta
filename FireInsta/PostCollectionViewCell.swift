//
//  PostCollectionViewCell.swift
//  FireInsta
//
//  Created by Sium on 8/23/17.
//  Copyright © 2017 Refat. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionViewCell: UICollectionViewCell {
  
    
    
    var postID: String!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var unlikeBtnOutlet: UIButton!
    
    @IBOutlet weak var likeBtnOutlet: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBAction func likeBtnAction(_ sender: Any) {
        
        
        self.likeBtnOutlet.isEnabled = false
        let ref = Database.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.likeLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes" : count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtnOutlet.isHidden = true
                                    self.unlikeBtnOutlet.isHidden = false
                                    self.likeBtnOutlet.isEnabled = true
                                }
                            }
                        })
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()

        
        
        
        
        
        /*self.likeBtnOutlet.isEnabled = false
        let ref = Database.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLikes/\(keyToPost)" : Auth.auth().currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLikes"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.likeLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes" : count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtnOutlet.isHidden = true
                                    self.unlikeBtnOutlet.isHidden = false
                                    self.likeBtnOutlet.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()*/
    }
    
    @IBAction func unlikeBtnAction(_ sender: Any) {
        
        self.unlikeBtnOutlet.isEnabled = false
        let ref = Database.database().reference()
        
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == Auth.auth().currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likeLabel.text = "\(count) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : count])
                                            }else {
                                                self.likeLabel.text = "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeBtnOutlet.isHidden = false
                            self.unlikeBtnOutlet.isHidden = true
                            self.unlikeBtnOutlet.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
            
        })
        ref.removeAllObservers()

        
        
        
        /*self.unlikeBtnOutlet.isEnabled = false
        let ref = Database.database().reference()
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLikes = properties["peopleWhoLikes"] as? [String : AnyObject] {
                    for (id, person) in peopleWhoLikes {
                        if person as? String == Auth.auth().currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLikes").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLikes"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likeLabel.text = "\(count) Likes"
                                                
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : count])
                                            } else {
                                                self.likeLabel.text = "0 Like"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            self.likeBtnOutlet.isHidden = false
                            self.unlikeBtnOutlet.isHidden = true
                            self.unlikeBtnOutlet.isEnabled = true
                            break
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()*/
    }
    
    
}
