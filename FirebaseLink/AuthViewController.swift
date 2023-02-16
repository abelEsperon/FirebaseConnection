//
//  AuthViewController.swift
//  FirebaseLink
//
//  Created by Abel Gonzalez on 02/02/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var AuthStackView: UIStackView!
    
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Authentication"
        // Do any additional setup after loading the view.
        Analytics.logEvent("InitScreen", parameters: ["message":"Integracion de Firebase"])
        
        // Comporbar la sesion del usuario autenticado,
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider") as? String {
            
            AuthStackView.isHidden = true
            navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType.init(rawValue: provider)!), animated: false)
        }
        
        // Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    override func viewWillAppear( _ _animated: Bool) {
        super.viewWillAppear(_animated)
        AuthStackView.isHidden = false
        
    }

    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwdTextField.text {
            Auth.auth() .createUser(withEmail: email, password: password) {
                (result, error) in

                if let result = result, error == nil {

                    self.navigationController?
                        .pushViewController(HomeViewController(email:
                                                                result.user .email!, provider: .basic), animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title:"Aceptar", style: .default))
                    self.present (alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logInButtonAction(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwdTextField.text {
            Auth.auth() .signIn(withEmail: email, password: password) {
                (result, error) in

                if let result = result, error == nil {

                    self.navigationController?
                        .pushViewController(HomeViewController(email:
                                                                result.user .email!, provider: .basic), animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title:"Aceptar", style: .default))
                    self.present (alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        
    }
    
extension AuthViewController: GIDSignDelegate {
    func sing(_ signIn: GIDSignIn!, didSignInFor user: GIDSignIn!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (AuthDataResult?, Error? ) in
                
            }
        }
    }
    
    }

}

