//
//  SignUpController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 5/11/2021.
//

import UIKit

class SignUpController: UIViewController {
    //var
    var clientVM = ClientViewModal()
    
    //widgets
    @IBOutlet weak var TFUserName: UITextField!
    @IBOutlet weak var TFPhoneNumber: UITextField!
    @IBOutlet weak var TFEmail: UITextField!
    @IBOutlet weak var TFPassword: UITextField!
    
    @IBOutlet weak var LabelUsername: UILabel!
    @IBOutlet weak var LabelPhone: UILabel!
    @IBOutlet weak var LabelEmail: UILabel!
    @IBOutlet weak var LabelPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Style UserName TestField
        TFUserName.layer.cornerRadius = 10.0
        TFUserName.layer.borderWidth = 1.0
        TFUserName.layer.masksToBounds = true
        
        //Style Phone Number TestField
        TFPhoneNumber.layer.cornerRadius = 10.0
        TFPhoneNumber.layer.borderWidth = 1.0
        TFPhoneNumber.layer.masksToBounds = true
        
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
    
        
        //releted to the button SignUp
        @IBAction func BtnSignUp(_ sender: Any) {
            if TFEmail.text! == "" || TFPassword.text! == "" || TFUserName.text! == "" || TFPhoneNumber.text == "" {
                alertMethod(titre: "Warning", message: " all Fields are required !")
            }else if TFPassword.text!.count < 7 {
                alertMethod(titre: "Warning", message: " password should be more than 7 caracters  !")
            }else if TFPhoneNumber.text!.count < 8 {
                alertMethod(titre: "Warning", message: " password should be more than 8 caracters  !")
            }else{
                ClientViewModal().createClient(username: TFUserName.text!, email: TFEmail.text!, password: TFPassword.text!, phone: TFPhoneNumber.text!, successHandler: {
                    self.dismiss(animated: true)
                }, errorHandler: {
                    self.alertMethod(titre: "warning", message: "client has not been created !!")
                })
            //clientVM.createClient(username: TFUserName.text!, email: TFEmail.text!, password: TFPassword.text!, phone: TFPhoneNumber.text!)
            }
        }
    
    
}
