//
//  SignInController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 5/11/2021.
//

import UIKit
import SwiftyJSON


class SignInController: UIViewController {
    
    //widgets
    @IBOutlet weak var TFEmail: UITextField!
    @IBOutlet weak var TFPassword: UITextField!
    
    @IBOutlet weak var LabelEmail: UILabel!
    @IBOutlet weak var LabelPassword: UILabel!
    @IBOutlet weak var LabelSignUp: UIButton!
    @IBOutlet weak var LabelForgot: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Style Email TestField
        TFEmail.layer.cornerRadius = 10.0
        TFEmail.layer.borderWidth = 1.0
        TFEmail.layer.masksToBounds = true
        
        //Style Password TestField
        TFPassword.layer.cornerRadius = 10.0
        TFPassword.layer.borderWidth = 1.0
        TFPassword.layer.masksToBounds = true
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
    }
        
    //IBActions
    
    @IBAction func BtnForgotPassword(_ sender: Any) {
        
        if !(TFEmail.text! == "" ) {
            performSegue(withIdentifier: "forgotPasswordSegue" , sender: sender)
        }else{
            alertMethod(titre: "Warning", message: "Email Field is required !")
        }
        
    }
    
        
        //releted to the button SignIn
        @IBAction func BtnSignIn(_ sender: Any) {
            if TFEmail.text! == "" || TFPassword.text! == ""{
                alertMethod(titre: "Warning", message: " all Fields are required !")
            }else if TFPassword.text!.count < 7 {
                alertMethod(titre: "Warning", message: " password should be more than 7 caracters  !")
            }
            else{

                ClientViewModal().login(email:  TFEmail.text!,password: TFPassword.text!, successHandler: {token in
                
                    let Vtoken = JSON(token)["token"].string
                    ClientViewModal().getuserfromtoken(token: Vtoken! , successHandler: {client in
                        
                        UserDefaults.standard.removeObject(forKey: "_id")
                        UserDefaults.standard.removeObject(forKey: "userName")
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "phoneNumber")
                        UserDefaults.standard.removeObject(forKey: "image")
                        
                        UserDefaults.standard.setValue(client._id! , forKey: "_id")
                        UserDefaults.standard.setValue(client.userName!, forKey: "userName")
                        UserDefaults.standard.setValue(client.email!, forKey: "email")
                        UserDefaults.standard.setValue(client.phoneNumber!, forKey: "phoneNumber")
                        UserDefaults.standard.setValue(client.image!, forKey: "image")
                        
                        self.performSegue(withIdentifier: "toHomeSegue", sender: sender )
                    }, errorHandler: {
                        self.alertMethod(titre: "warning", message: "could not login re try after")
                    })
                    
                }, errorHandler: {
                    self.alertMethod(titre: "warning", message: "could not find this user")
                })
                
                
                
            }
        }
    
    //methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeSegue"{

            
        }else if segue.identifier == "forgotPasswordSegue" {
                let destination = segue.destination as! InterEmailViewController
                destination.accountEmail = TFEmail.text!
            
        }else if segue.identifier == "toHomeSegue2" {

    }
        
    }
    

}
