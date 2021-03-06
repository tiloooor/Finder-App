//
//  RegisterViewController.swift
//  Finder
//
//  Created by Tyler Holloway on 7/20/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Parse
import LocalAuthentication

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var selectProfilePicBtnTitle: UIButton!
    
    var interest: [String] = []
    
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true) { 
            //do nothing 
        }
    }
    
    @IBAction func selectProfilePhoto(_ sender: Any) {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        registerButton.isHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        loadGif()
        
        registerButton.isHidden = true
    }
    
    func loadGif() {
        gifView.loadGif(name: "login")
    }
    
    func updateUI() {
        // Make Placeholder white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("RegisUsername", comment: "Username for registration"), attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("RegisPassword", comment: "Password for registration"), attributes: [NSForegroundColorAttributeName: UIColor.white])

        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        fullNameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("RegisFullName", comment: "Fullname registration"), attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        selectProfilePicBtnTitle.setTitle(NSLocalizedString("SelectProfPicTitle", comment: "Title of button to select profile picture"), for: .normal)

        
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
        
        
        var ourYellow = UIColor(red: 249/255, green: 208/255, blue: 16/255, alpha: 0.75)
        registerButton.backgroundColor = ourYellow
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
        
        profilePhotoImageView.layer.cornerRadius = 72
        profilePhotoImageView.layer.masksToBounds = true
        
    }
    
    // Register user
    @IBAction func pressRegister(_ sender: Any) {
        
        //Initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.email = emailTextField.text
        
        // PROFILE IMAGE
        let profileImageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if profileImageData != nil {
            // Make sure have got all of the information to be send to Parse Cloud services
            let profileImageFile = PFFile(data: profileImageData!)
            newUser.setObject(profileImageFile, forKey: "profile_picture")
            self.createFields(user: newUser)
        }
        
        // Call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Yay, registered new user!")
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func createFields(user: PFUser) {
        //let defaultIcon = Fact.getPFFileFromImage(image: UIImage(named: "Image-6"))
        let defaultBookmarks: [PFObject] = []
        let defaultFollows: [PFUser] = []
        let seen: [Int] = []
        //user.setObject(defaultIcon, forKey: "prof_pic")
        user.setObject(defaultBookmarks, forKey: "bookmarks")
        user.setObject(defaultFollows, forKey: "followers")
        user.setObject(defaultFollows, forKey: "following")
        user.setObject(defaultBookmarks, forKey: "timeline")
        user.setObject(seen, forKey: "seen")
        user.setObject(interest, forKey: "interests")
    }
    
    
    @IBAction func pushKeyboardDown(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func goBackToLogin(_ sender: Any) {
        dismiss(animated: true) { 
             self.performSegue(withIdentifier: "alreadyMember", sender: self)
        }
    }
    
    
    // Authenticate user with TouchID
    func authenticateUser() {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use TouchID
            
        } else {
            // Device cannot use TouchID
            switch error!.code{
                
            case LAError.Code.touchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",
                           err: error?.localizedDescription)
                
            case LAError.Code.passcodeNotSet.rawValue:
                notifyUser("A passcode has not been set",
                           err: error?.localizedDescription)
                
            default:
                notifyUser("TouchID not available",
                           err: error?.localizedDescription)
                
            }
        }    
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }

    
    @IBAction func pressTouchID(_ sender: Any) {
        
        authenticateUser()
        
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
