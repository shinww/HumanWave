//
//  FakeFeed.swift
//  HumanWave
//
//  Created by shinwee on 2/20/17.
//  Copyright © 2017 shinwee. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FakeFeed: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Signout(_ sender: Any) {
        KeychainWrapper.standard.remove(key: KEY_UID)
        print("BERNARD: ID removed from keychain")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier:"goToLoginVC", sender: nil)
    }
    
        
            }

