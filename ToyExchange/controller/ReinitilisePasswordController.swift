//
//  ReinitilisePasswordController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 28/11/2021.
//

import UIKit

class ReinitilisePasswordController : UIViewController {
    //var
    var clientVM = ClientViewModal()
    var code : Int?
    var email :String?
    var accountEmail:String?
    //IBOtlets
    @IBOutlet weak var TFPassword: UITextField!
    @IBOutlet weak var TFConfirmPassword: UITextField!
    @IBOutlet weak var LabelTitle: UILabel!
    
    @IBOutlet weak var LabelPassword: UILabel!
    @IBOutlet weak var LabelNewPassword: UILabel!
    
    //lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Style Password TestField
        TFPassword.layer.cornerRadius = 10.0
        TFPassword.layer.borderWidth = 1.0
        TFPassword.layer.masksToBounds = true
        //Style ConfirmPassword TestField
        TFConfirmPassword.layer.cornerRadius = 10.0
        TFConfirmPassword.layer.borderWidth = 1.0
        TFConfirmPassword.layer.masksToBounds = true
        
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
    @IBAction func ReinitialiseAction(_ sender: Any) {
        if(TFPassword.text! == TFConfirmPassword.text! && !(TFPassword.text!.isEmpty) && !(TFConfirmPassword.text!.isEmpty) ){
            //clientVM.reinitialisePassword(email: self.accountEmail! , newPassword: TFPassword.text!)
            ClientViewModal().reinitialisePassword(email: self.accountEmail!, newPassword: TFPassword.text!, successHandler: {
                self.alertMethod(titre: "Success", message: "password has been reinitialised !")
            }, errorHandler: {
                self.alertMethod(titre: "Warning", message: "password hasn't been reinitialized !")
            })
            
        }else if (TFPassword.text!.isEmpty || TFConfirmPassword.text!.isEmpty){
            self.alertMethod(titre: "Warning", message: "password or confirm password is empty !")
        }
        else{
            self.alertMethod(titre: "Warning", message: "password and confirm password should be the same !")
        }
    }

}
