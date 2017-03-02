//
//  FeedVC.swift
//  HumanWave
//
//  Created by shinwee on 2/18/17.
//  Copyright © 2017 shinwee. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {
//, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
////
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var imageAdd: CircleView!
      @IBOutlet weak var userNameTitle: UILabel!
      @IBOutlet weak var profilePicOutput: CircleView!
    
    
    override func viewDidLoad() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        DB_BASE.child("userDetail").child(uid!).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let profileImg = dict["profileImg"] as? String
            
            let storageRef = FIRStorage.storage().reference(forURL: profileImg!)
            storageRef.data(withMaxSize: 1 * 1024 * 1024) {
                data, error in
                if error != nil {
                    print("Bernard: \(error?.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    self.profilePicOutput.image = image
                }}
            }
        } )
        
            DB_BASE.child("userDetail").child(uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.userNameTitle.text = dictionary["userName"] as? String
            }
       } )
    }
            

    //
//    
//    var posts = [Post]()
//    var imagePicker: UIImagePickerController!
//    //static var imageCache: Cache<NSString, UIImage> = Cache()
//    static var imageCache: NSCache<NSString, UIImage> = NSCache()
//    var imageSelected = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//    
//        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
//
//            self.posts = [] // THIS IS THE NEW LINE
//            
//            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshot {
//                    print("SNAP: \(snap)")
//                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let post = Post(postKey: key, postData: postDict)
//                        self.posts.append(post)
//                    }
//                }
//            }
//            self.tableView.reloadData()
//        })
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let post = posts[indexPath.row]
//        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
//            
//            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
//                cell.configureCell(post: post, img: img)
//            } else {
//                cell.configureCell(post: post)
//            }
//            return cell
//        } else {
//            return PostCell()
//        }
//    }
//
//    
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//            imageAdd.image = image
//            imageSelected = true
//        } else {
//            print("BERNARD: A valid image wasn't selected")
//        }
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func addImageTapped(_ sender: AnyObject) {
//        present(imagePicker, animated: true, completion: nil)
//    }
    
//    @IBAction func postBtnTapped(_ sender: AnyObject) {
//        guard let caption = captionField.text, caption != "" else {
//            print("BERNARD: Caption must be entered")
//            return
//        }
//        guard let img = imageAdd.image, imageSelected == true else {
//            print("BERNARD: An image must be selected")
//            return
//        }
//        
//        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
//            
//            let imgUid = NSUUID().uuidString
//            let metadata = FIRStorageMetadata()
//            metadata.contentType = "image/jpeg"
//            
//            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
//                if error != nil {
//                    print("BERNARD: Unable to upload image to Firebasee torage")
//                } else {
//                    print("BERNARD: Successfully uploaded image to Firebase storage")
//                    let downloadURL = metadata?.downloadURL()?.absoluteString
//                    if let url = downloadURL {
//                        self.postToFirebase(imgUrl: url)
//                    }
//                }
//            }
//        }
//    }
    
//    func postToFirebase(imgUrl: String) {
//        let post: Dictionary<String, AnyObject> = [
//            "caption": captionField.text! as AnyObject,
//            "imageUrl": imgUrl as AnyObject,
//            "likes": 0 as AnyObject
//        ]
//        
//        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
//        firebasePost.setValue(post)
//        
//        captionField.text = ""
//        imageSelected = false
//        imageAdd.image = UIImage(named: "add-image")
//        
//        tableView.reloadData()
//    }
    
//        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
//        print("BERNARD: ID removed from keychain \(keychainResult)")
//        try! FIRAuth.auth()?.signOut()
//        performSegue(withIdentifier: "goToLoginVC", sender: nil)
    
    @IBAction func signOut(_ sender: Any) {
        KeychainWrapper.standard.remove(key: KEY_UID)
        print("BERNARD: ID removed from keychain")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier:"goToLoginVC", sender: nil)
    }
    
    }


