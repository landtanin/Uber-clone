//
//  ViewController.swift
//  Uber-clone
//
//  Created by Tanin on 22/11/2017.
//  Copyright © 2017 landtanin. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var riderDriverSwitch: UISwitch!
    @IBOutlet var topButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    @IBOutlet var riderLabel: UILabel!
    @IBOutlet var driverLabel: UILabel!
    
    var signUpMode = true
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // banner ad
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        ////////////////////////////////////////////////////////////
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        
        
        
    }
    
    @IBAction func topTapped(_ sender: UIButton) {
        
        // intersitial ad
        //        if interstitial.isReady {
        //            interstitial.present(fromRootViewController: self)
        //        }
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing information", message: "Please enter email and password")
        } else {
            
            if let email = emailTextField.text {
                
                if let password = passwordTextField.text {
                    
                    if signUpMode {
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                
                            } else {
                                print("Sign Up Success")
                                
                                if self.riderDriverSwitch.isOn {
                                    
                                    // DRIVER
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                    
                                } else {
                                    
                                    // RIDER
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                    
                                }
                                
                            }
                            
                        })
                    } else {
                        
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                
                            } else {
                                
                                print("Login Successful")
                                
                                if user?.displayName == "Driver" {
                                    
                                    // DRIVER
                                    print("driver")
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                    
                                } else {
                                    
                                    // RIDER
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                    
                                }
                                
                            }
                            
                        })
                        
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    func displayAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func bottomButton(_ sender: UIButton) {
        
        if signUpMode {
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
        } else {
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
            signUpMode = true
        }
        
    }
    
    
}

