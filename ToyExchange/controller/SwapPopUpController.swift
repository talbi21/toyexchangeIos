//
//  SwapPopUpController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 22/12/2021.
//

import UIKit

class SwapPopUpController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //var
    var ToyVM = ToyViewModal()
    var myToyList : [Toy] = []
    //variable function type specify the input and output parameters
    var onChoose : ((_ data: Toy) -> ())?
    
    //IBOutlets
    
    @IBOutlet weak var TVToy: UITableView!
    
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
    }
    
    
    //methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myToyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"toyCell")

        let contentView = cell?.contentView
        let toyImg = contentView?.viewWithTag(1) as! UIImageView
        let toyName = contentView?.viewWithTag(2) as! UILabel
        
        var path = String("http://localhost:3000/"+(myToyList[indexPath.row].Image)!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        toyImg.af.setImage(withURL: url)
        toyImg.layer.cornerRadius = 10.0
        toyImg.layer.borderWidth = 1.0
        toyImg.layer.borderColor = UIColor.clear.cgColor
        toyImg.layer.shadowColor = UIColor.gray.cgColor
        toyImg.layer.shadowRadius = 9.0
        toyImg.layer.shadowOpacity = 0.5
        toyImg.layer.shadowPath = UIBezierPath(roundedRect: toyImg.bounds, cornerRadius: toyImg.layer.cornerRadius).cgPath
        
        toyImg.clipsToBounds = true
        toyImg.layer.masksToBounds = true
        
        toyName.text = myToyList[indexPath.row].Name!
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onChoose?( (myToyList[indexPath.row]) )
        print("toy selected from popup")
        print( (myToyList[indexPath.row]) )
        dismiss(animated: true)
    }
    
    @IBAction func ClosePoPUp(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
