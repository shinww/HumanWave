//
//  emailSignInVC.swift
//  HumanWave
//
//  Created by shinwee on 2/20/17.
//  Copyright © 2017 shinwee. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EmailSignInVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var pwdField: RoundTextField!
    @IBOutlet weak var userNameField: RoundTextField!
    @IBOutlet weak var profileImg: CircleView!
    
    var imagePicker: UIImagePickerController!
    //static var imageCache: Cache<NSString, UIImage> = Cache()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
     }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImg.image = image
            imageSelected = true
        } else {
            print("BERNARD: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func profileImgTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)

    }

@IBAction func signInTapped(_ sender: RoundBtn) {
    
    guard let email = emailField.text, let pwd = pwdField.text, let userName = userNameField.text?.capitalizingFirstLetter() else {
    print("BERNARD: Form is not Valid")
        return
    }
    
    guard let img = profileImg.image, imageSelected == true else {
        print("BERNARD: An image must be selected")
        return
    }

    
    
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
            if error == nil {
                print("BERNARD: Email user authenticated with firebase")
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil {
                        print("Bernard: Unable to authenticate with firebase using email")
                    } else {
                        
                        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
                            
                            let imgUid = NSUUID().uuidString
                            let metadata = FIRStorageMetadata()
                            metadata.contentType = "image/jpeg"
                            
                            DataService.ds.REF_PROFILE_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                                if error != nil {
                                    print("BERNARD: Unable to upload image to Firebasee storage")
                                } else {
                                    print("BERNARD: Successfully uploaded image to Firebase storage")
                                    let downloadURL = metadata?.downloadURL()?.absoluteString
                                }
                                
                                self.imageSelected = false
                                self.profileImg.image = UIImage(named: "profile-pic")
                                
                                let userDetails = ["userName": userName, "email": email, "profileImg": metadata?.downloadURL()?.absoluteString]
                                
                                DB_BASE.child("userDetail").child((user?.uid)!).updateChildValues(userDetails)
                            }
                        }
                        print("Bernard: Successfully authenticated with firebase")
                                                
                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
            }
        })
}
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, userDetails: [String: Any]) {
        
    }
   
    
    
    
//    func userDetailToFirebase(imgUrl: String) {
//        let userDetail: Dictionary<String, AnyObject> = [
//            "profileImgURL": imgUrl as AnyObject,
//        ]
//        
//        let firebaseUserDetail = DataService.ds.REF_USERDETAIL.
//        firebaseUserDetail.setValue(userDetail)
//        
//        imageSelected = false
//        profileImg.image = UIImage(named: "profile-pic")
//        
//      
//    }

    
    func completeSignIn(id: String, userData: Dictionary<String,String>) {
    DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
    let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
    print("BERNARD: Data saved to keychain \(keychainResult)")
    performSegue(withIdentifier: "goToFeed", sender: nil)
    
    
}

}

