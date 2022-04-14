//
//  PostDemandListController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 14/11/2021.
//

import UIKit

class PostDemandListController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

    //var
    var selectedToy : Toy?
    var DemandList : [Swap] = []
    var ClientsList : [Client] = []
    var clientVM = ClientViewModal()
    
    @IBOutlet weak var TVDemandsList: UITableView!
    
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        SwapViewModal.shared.getDemandsByToy(toyId: (selectedToy?._id)! , successHandler: {
            list in  self.DemandList = list
            self.TVDemandsList.reloadData()
        }, errorHandler:{

        } )
        
        //get clients list
        self.clientVM.getAllClients( successHandler: {anomalyList in
            self.ClientsList.append(contentsOf: anomalyList)
    
            self.TVDemandsList.reloadData()
        }, errorHandler:{
            
        } )
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.DemandList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"myDemandsCell")
        
        let contentView = cell?.contentView
        let toyImg = contentView?.viewWithTag(1) as! UIImageView
        let demandType = contentView?.viewWithTag(2) as! UILabel
        let sendBy = contentView?.viewWithTag(3) as! UILabel
        
        //----------------------------------------------
        toyImg.layer.cornerRadius = 10.0
        toyImg.layer.borderWidth = 1.0
        toyImg.layer.borderColor = UIColor.clear.cgColor
        toyImg.layer.shadowColor = UIColor.gray.cgColor
        toyImg.layer.shadowRadius = 9.0
        toyImg.layer.shadowOpacity = 0.5
        toyImg.layer.shadowPath = UIBezierPath(roundedRect: toyImg.bounds, cornerRadius: toyImg.layer.cornerRadius).cgPath
        
        toyImg.clipsToBounds = true
        toyImg.layer.masksToBounds = true
        //----------------------------------------------
        
        

        for i in (0..<ClientsList.count) {

            if ClientsList[i]._id == DemandList[indexPath.row].IdClient1 {

                var path = String("http://localhost:3000/"+ClientsList[i].image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
                
                let url = URL(string: path)!
                toyImg.af.setImage(withURL: url)
                
                //demandType.text = DemandList[indexPath.row].SwapType
                sendBy.text = ClientsList[i].userName
            }
            
            demandType.text = DemandList[indexPath.row].SwapType
            
        }
        
        return cell!
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToQRCode", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToQRCode" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! QRCodeController
            
            destination.swapID = DemandList[indexPath.row]._id
        }
    }
    
}
