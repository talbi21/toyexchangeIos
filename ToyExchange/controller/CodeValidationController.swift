//
//  CodeValidationController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 28/11/2021.
//

import UIKit

class CodeValidationController: UIViewController {
    //var
    var code : Int?
    var email:String?
    
    var accountEmail:String?
    //IBOutltes
    @IBOutlet weak var TFValidationCode: UITextField!
    @IBOutlet weak var LabelEmail: UILabel!
    
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var LabelDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Style Validation Code TestField
        TFValidationCode.layer.cornerRadius = 10.0
        TFValidationCode.layer.borderWidth = 1.0
        TFValidationCode.layer.masksToBounds = true
        LabelEmail.text = email
        
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
    @IBAction func VerifyCodeAction(_ sender: Any) {
        let textfieldInt: Int? = Int(TFValidationCode.text!)
        if self.code == textfieldInt {
            performSegue(withIdentifier: "verifyCodeSegue", sender: sender)
        }else{
            self.alertMethod(titre: "Warning", message: "Code is incorrect !")
        }
        
    }
    
    //methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "verifyCodeSegue"{
                let destination = segue.destination as! ReinitilisePasswordController
                destination.email = self.email
                destination.accountEmail = self.accountEmail
            }
    }
    
}
