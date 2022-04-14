//
//  AppSettingsController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 14/11/2021.
//
import UIKit

class AppSettingsController: UIViewController, UNUserNotificationCenterDelegate {
    
    //widgets
    @IBOutlet weak var TFOldPassword: UITextField!
    @IBOutlet weak var TFNewPassword: UITextField!
    @IBOutlet weak var TFConfirmNewPassword: UITextField!
    
    @IBOutlet weak var switchDark: UISwitch!
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Style OldPassword TestField
        TFOldPassword.layer.cornerRadius = 10.0
        TFOldPassword.layer.borderWidth = 1.0
        TFOldPassword.layer.masksToBounds = true
        
        //Style New Password TestField
        TFNewPassword.layer.cornerRadius = 10.0
        TFNewPassword.layer.borderWidth = 1.0
        TFNewPassword.layer.masksToBounds = true
        
        //Style Confirm Password TestField
        TFConfirmNewPassword.layer.cornerRadius = 10.0
        TFConfirmNewPassword.layer.borderWidth = 1.0
        TFConfirmNewPassword.layer.masksToBounds = true
        
        if(UserDefaults.standard.bool(forKey: "IsDark")){
            switchDark.setOn(true, animated: false)
            overrideUserInterfaceStyle = .dark
        }else{
            switchDark.setOn(false, animated: false)
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
    @IBAction func SwitchDarkMode(_ sender: UISwitch) {
        if #available(iOS 13.0, *) {
                 if sender.isOn {
                     let IsDark = true
                     UserDefaults.standard.setValue(IsDark , forKey: "IsDark")
                     overrideUserInterfaceStyle = .dark
                     return
                 }else{
                     let IsDark = false
                     UserDefaults.standard.setValue(IsDark , forKey: "IsDark")
                     overrideUserInterfaceStyle = .light

                      return
                 }
        }
    }

    @IBAction func SwitchNotification(_ sender: UISwitch) {
        if #available(iOS 10.0, *) {
            if sender.isOn {
           // For iOS 10.0 +
           let center  = UNUserNotificationCenter.current()
           center.delegate = self
           center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                   DispatchQueue.main.async(execute: {
                         UIApplication.shared.registerForRemoteNotifications()
                   })
                }
           }
            }}else{
            // Below iOS 10.0
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)

            //or
            //UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
        //releted to the button Update password
        @IBAction func BtnUpdatePassword(_ sender: Any) {
            if(TFNewPassword.text! == TFConfirmNewPassword.text!){
                //ClientViewModal().updatePassword(id: UserDefaults.standard.string(forKey:"_id")!, newPassword: TFNewPassword.text!,oldPassword: TFOldPassword.text!)
                
                ClientViewModal().updatePassword(id: UserDefaults.standard.string(forKey:"_id")!, newPassword: TFNewPassword.text!, oldPassword: TFOldPassword.text!, successHandler: {
                    self.alertMethod(titre: "success ", message: "password updated successfully")
                }, errorHandler: {
                    self.alertMethod(titre: "warning ", message: "password hasn't been updated !!!")
                })
                
            }else if TFNewPassword.text! == TFConfirmNewPassword.text!{
                self.alertMethod(titre: "Warning", message: "new password and confirm password should be the same !")
            }
            else{
                self.alertMethod(titre: "Warning", message: "all the fields are required !")
            }
        }


}
