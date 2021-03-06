//
//  LoginViewController.swift
//  Finder
//
//  Created by Tyler Holloway on 7/11/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Parse



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK: Properties
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var ForgotPasswordButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadGif()
        updateUI()
    }
    
    func loadGif() {
        gifView.loadGif(name: "login")
    }
    
    func updateUI() {
        // Make placeholder text white
        usernameLabel.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Username", comment: "This is the username"), attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        passwordLabel.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: "This is the password"), attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        loginButton.setTitle(NSLocalizedString("Login", comment: "Login button"), for: .normal)
        
        createAccountButton.setTitle(NSLocalizedString("CreateAccount", comment: "Create account button title"), for: .normal)
        
        ForgotPasswordButton.setTitle(NSLocalizedString("ForgotPassword", comment: "Forgot password button title"), for: .normal)
        
        
        // make corners round
        usernameLabel.layer.cornerRadius = 10
        usernameLabel.layer.masksToBounds = true
        usernameLabel.layer.borderWidth = 1
        usernameLabel.layer.borderColor = UIColor.white.cgColor
        
        passwordLabel.layer.cornerRadius = 10
        passwordLabel.layer.masksToBounds = true
        passwordLabel.layer.borderWidth = 1
        passwordLabel.layer.borderColor = UIColor.white.cgColor
        
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        var ourYellow = UIColor(red: 249/255, green: 208/255, blue: 16/255, alpha: 0.75)
        loginButton.backgroundColor = ourYellow
        
    }
    
    // Login User with Parse Authentication
    @IBAction func pressLogin(_ sender: Any) {
        
            //check if user entered password and alert
            let username = self.usernameLabel.text ?? ""
            let password = self.passwordLabel.text ?? ""
        
        let loginAlertController = UIAlertController(title: NSLocalizedString("loginAlertTitle", comment: "Title of the alert"), message: NSLocalizedString("loginAlertMessage", comment: "Alert message displayed"), preferredStyle: .alert)
        
        let signInErrorAlert = UIAlertController(title: NSLocalizedString("signInAlertTitle", comment: "Sign in error alert"), message: NSLocalizedString("signInAlertMessage", comment: "Alert message displayed"), preferredStyle: .alert)
            
            if username.isEmpty || password.isEmpty{
                
                //alert user
                self.present(signInErrorAlert, animated: true)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                    self.passwordLabel.text = nil
                }
                
                // add the OK action to the alert controller
                signInErrorAlert.addAction(OKAction)
                //self.present(success, animated: false, completion: nil)
                
            } else {
                
                PFUser.logInWithUsername(inBackground: usernameLabel.text!, password: passwordLabel.text!) { (user: PFUser?, error: Error?) in
                    if let error = error{
                        
                        self.present(loginAlertController, animated: true)
                        // create an OK action
                        
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            // handle response here.
                            
                            self.passwordLabel.text = nil
                        }
                        
                        loginAlertController.addAction(OKAction)
                        
                        print("User log in failed: \(error.localizedDescription)")
                    } else{
                        if user != nil {
                            print("You're logged in!")
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    }
                }
                
            } //end of else
        
        
    }
    
    @IBAction func pushKeyboardDown(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
