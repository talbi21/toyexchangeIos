//
//  InterEmailViewController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 28/11/2021.
//

import UIKit

class InterEmailViewController: UIViewController {
    //var
    var code : Int?
    var email:String?
    var accountEmail:String?
    
    //IBOutlets
    @IBOutlet weak var TFEmail: UITextField!
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var LabelDesc: UILabel!
    
    
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style Email TestField
        TFEmail.layer.cornerRadius = 10.0
        TFEmail.layer.borderWidth = 1.0
        TFEmail.layer.masksToBounds = true
        
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
    
    @IBAction func ConfirmEmailAction(_ sender: Any) {
        if !(TFEmail.text!.isEmpty) {
            self.email = TFEmail.text!
            self.code = Int.random(in:10000 ..< 100000)
            
            ClientViewModal().sendEmail(email: self.email!, code: self.code!, successHandler: {
                    self.performSegue(withIdentifier: "confirmEmailSegue", sender:sender)
            }, errorHandler: {
                self.alertMethod(titre: "warning", message: "the email hasn't been sent" )
            })
            
        }else{
            self.alertMethod(titre: "Warning", message: "Email Field is required !")
        }
        
        
    }
    
    //methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "confirmEmailSegue"{
                let destination = segue.destination as! CodeValidationController
                destination.code = self.code
                destination.email = self.email
                destination.accountEmail = self.accountEmail
            }
    }

    
    
}
