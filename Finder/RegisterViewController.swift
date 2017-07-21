//
//  RegisterViewController.swift
//  Finder
//
//  Created by Tyler Holloway on 7/20/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true) { 
            //do nothing 
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        loadGif()
        
    }
    
    func loadGif() {
        gifView.loadGif(name: "login")
    }
    
    func updateUI() {
        // make corners round
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.masksToBounds = true
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.white.cgColor
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        
        fullNameTextField.layer.cornerRadius = 10
        fullNameTextField.layer.masksToBounds = true
        fullNameTextField.layer.borderWidth = 1
        fullNameTextField.layer.borderColor = UIColor.white.cgColor
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        
        
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
        
    }
    
    // Register user
    @IBAction func pressRegister(_ sender: Any) {
        
        //Initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        // Call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Yay, registered new user!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
