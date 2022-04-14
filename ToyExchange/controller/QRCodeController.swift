//
//  QRCodeController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 9/11/2021.
//

import UIKit
import Alamofire

class QRCodeController: UIViewController {
    //var
    var swapID:String?
    
    //IBOutlets
    @IBOutlet weak var IMVQRCode: UIImageView!
    
    @IBOutlet weak var LabelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateAction()

        
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
    
    //methods
    func generateAction() {
        if let name = swapID {
            let combinedString = "\(name)"
            IMVQRCode.image = generateQRCode(Name:combinedString)!
        }
    }

    func generateQRCode(Name: String) -> UIImage? {
        let name_data = Name.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(name_data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    

}
