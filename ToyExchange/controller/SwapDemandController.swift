//
//  SwapDemandController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 6/11/2021.
//

import UIKit
import Alamofire

class SwapDemandController: UIViewController {
    
    //var
    var toyToDemand : Toy?
    var myToyList : [Toy] = []
    
    var popUpChosenToy : Toy?=nil
    //widgets
    @IBOutlet weak var IMVPostDemanded: UIImageView!
    @IBOutlet weak var IMVToyToSwapWith: UIImageView!
    @IBOutlet weak var LabelPostPrice: UILabel!
    
    @IBOutlet weak var LabelTitle: UILabel!
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
        if (IsDark == true){
            LabelTitle.layer.borderColor = UIColor.white.cgColor

        }else{
            LabelTitle.layer.borderColor = UIColor.black.cgColor
        }
        
        //----------------------------------------------
        IMVPostDemanded.layer.cornerRadius = 10.0
        IMVPostDemanded.layer.borderWidth = 1.0
        IMVPostDemanded.layer.borderColor = UIColor.clear.cgColor
        IMVPostDemanded.layer.shadowColor = UIColor.gray.cgColor
        IMVPostDemanded.layer.shadowRadius = 9.0
        IMVPostDemanded.layer.shadowOpacity = 0.5
        IMVPostDemanded.layer.shadowPath = UIBezierPath(roundedRect: IMVPostDemanded.bounds, cornerRadius: IMVPostDemanded.layer.cornerRadius).cgPath
        
        IMVPostDemanded.clipsToBounds = true
        IMVPostDemanded.layer.masksToBounds = true
        
        
        IMVToyToSwapWith.layer.cornerRadius = 10.0
        IMVToyToSwapWith.layer.borderWidth = 1.0
        IMVToyToSwapWith.layer.borderColor = UIColor.clear.cgColor
        IMVToyToSwapWith.layer.shadowColor = UIColor.gray.cgColor
        IMVToyToSwapWith.layer.shadowRadius = 9.0
        IMVToyToSwapWith.layer.shadowOpacity = 0.5
        IMVToyToSwapWith.layer.shadowPath = UIBezierPath(roundedRect: IMVToyToSwapWith.bounds, cornerRadius: IMVToyToSwapWith.layer.cornerRadius).cgPath
        
        IMVToyToSwapWith.clipsToBounds = true
        IMVToyToSwapWith.layer.masksToBounds = true
        //----------------------------------------------
        
        var path = String("http://localhost:3000/"+toyToDemand!.Image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        IMVPostDemanded.af.setImage(withURL: url)

        LabelPostPrice.text = "$ "+toyToDemand!.Price!
        //popup list data
        ToyViewModal().getOwnerToy(OwnerId: UserDefaults.standard.string(forKey:"_id")! , successHandler: {anomalyList in
            self.myToyList = anomalyList
            print(self.myToyList)
        }, errorHandler: {
            print("errorororoor")
        })
        
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
    @IBAction func BtnSwapDemand(_ sender: Any) {
        if popUpChosenToy == nil {
            print("popUp field is empty")
        }else {
            var demand = Swap()
            demand.IdClient1 = UserDefaults.standard.string(forKey:"_id")!
            demand.IdClient2 = toyToDemand?.OwnerId!
            demand.IdToy1 = popUpChosenToy?._id!
            demand.IdToy2 = toyToDemand?._id!
            demand.Confirmed = "false"
            print("demand swap begin")
            print(demand)
            print("demand swap end")
            
            SwapViewModal().addSwapDemand(swapDemand: demand, successHandler:{
                self.alertMethod(titre: "success", message: "swap made successfully ")
            } , errorHandler: {
                self.alertMethod(titre: "warning", message: "swap has not been sent !!! ")
            }, noResponseHandler: {
                print("swap demand no response")
            })
        }
        
    }
    
    @IBAction func BtnBuyDemand(_ sender: Any) {
        
        var demand = Swap()
        demand.IdClient1 = UserDefaults.standard.string(forKey:"_id")!
        demand.IdClient2 = toyToDemand?.OwnerId!
        demand.IdToy2 = toyToDemand?._id!
        demand.Confirmed = "false"
        print("demand buy begin")
        print(demand)
        print("demand buy end")
        SwapViewModal().addBuyDemand(buyDemand: demand, successHandler:{
            self.alertMethod(titre: "success", message: "demand to buy made successfully ")
        } , errorHandler: {
            self.alertMethod(titre: "success", message: "buy demand made successfully ")
        }, noResponseHandler: {
            print("buy demand no response")
        })
        

    }
    
    @IBAction func BtnSelectToy(_ sender: Any) {
        performSegue(withIdentifier: "ToPopupSegue", sender: sender)
    }
    
    //methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPopupSegue" {
            let destination = segue.destination as! SwapPopUpController
            destination.myToyList = self.myToyList
            //callback onchoose function to get the selected row data
            //assign to function
            destination.onChoose = onChoose
            
        }
    }
    
    func onChoose (_ data: Toy) -> () {
        popUpChosenToy = data
        print("chosen toy is ")
        print(popUpChosenToy!)
        
        var path = String("http://localhost:3000/"+popUpChosenToy!.Image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        IMVToyToSwapWith.af.setImage(withURL: url)
        
    }
    
}
