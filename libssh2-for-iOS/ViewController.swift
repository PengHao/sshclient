//
//  ViewController.swift
//  libssh2-for-iOS
//
//  Created by Felix Schulze on 01.02.11.
//  Copyright 2010-2015 Felix Schulze. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var ipField: UITextField!
    @IBOutlet var userField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var textView: UITextView!

    
    @IBAction
    func showInfo() {
        let message = "libssh2-Version: \(LIBSSH2_VERSION)\nlibgcrypt-Version: \(GCRYPT_VERSION)\nlibgpg-error-Version: 1.12\nopenssl-Version:\(OPENSSL_VERSION_TEXT)\nLicense: See include/LICENSE\n\nCopyright 2010-2015 by Felix Schulze\n http://www.felixschulze.de"
        let alertController = UIAlertController(title: "libssh2-for-iOS", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction
    func executeCommaned() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return;
        }
        appDelegate.sshWrapper = SSHWrapper(host: ipField.text, port: 22)
        var error: NSError?
        appDelegate.sshWrapper.connectUser(userField.text, password: passwordField.text, error: &error)
        
        if error != nil {
            let alertController = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let vc = TerminalViewController(nibName: "TerminalViewController", bundle: nil)
            UserDefaults.standard.set(ipField.text, forKey: "ip")
            UserDefaults.standard.set(userField.text, forKey: "user")
            UserDefaults.standard.set(passwordField.text, forKey: "pwd")
            UserDefaults.standard.synchronize()
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "libssh2-for-iOS"
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(ViewController.showInfo), for: .touchDown)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        ipField.text = UserDefaults.standard.string(forKey: "ip")
        userField.text = UserDefaults.standard.string(forKey: "user")
        passwordField.text = UserDefaults.standard.string(forKey: "pwd")
    }
}
