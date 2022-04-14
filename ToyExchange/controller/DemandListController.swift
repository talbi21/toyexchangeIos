//
//  NotificationsControllerViewController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 7/11/2021.
//

import UIKit

class DemandListController: UIViewController  ,UITableViewDelegate,UITableViewDataSource{
    //var
    var demandList = [Swap]();
    var toyList = [Toy]();
    //IBOutlets
    @IBOutlet weak var DemandsTV: UITableView!
    
    
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        initalise()
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
    }

    
    //methods
    
    func initalise(){
        SwapViewModal().demandByClient1(IdClient1: UserDefaults.standard.string(forKey:"_id")!  , successHandler:{anomalyList in
            self.demandList.removeAll()
            self.demandList.append(contentsOf: anomalyList)
            self.DemandsTV.reloadData()
        } , errorHandler: {
            
        })
        
        ToyViewModal().getToys(successHandler: {anomalyList in
            self.toyList.removeAll()
            self.toyList.append(contentsOf: anomalyList)
            self.DemandsTV.reloadData()
        }, errorHandler: {
            
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "qrSegue"{
            
        
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demandList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"demandCell")
        let contentView = cell?.contentView

        let ToyImg1 = contentView?.viewWithTag(1) as! UIImageView
        let ToyImg2 = contentView?.viewWithTag(2) as! UIImageView
        let ToyDescription = contentView?.viewWithTag(3) as! UILabel
    
        //------------------------------------------------------------
        ToyImg1.layer.cornerRadius = 10.0
        ToyImg1.layer.borderWidth = 1.0
        ToyImg1.layer.borderColor = UIColor.clear.cgColor
        ToyImg1.layer.shadowColor = UIColor.gray.cgColor
        ToyImg1.layer.shadowRadius = 9.0
        ToyImg1.layer.shadowOpacity = 0.5
        ToyImg1.layer.shadowPath = UIBezierPath(roundedRect: ToyImg1.bounds, cornerRadius: ToyImg1.layer.cornerRadius).cgPath
        
        ToyImg1.clipsToBounds = true
        ToyImg1.layer.masksToBounds = true
        
        ToyImg2.layer.cornerRadius = 10.0
        ToyImg2.layer.borderWidth = 1.0
        ToyImg2.layer.borderColor = UIColor.clear.cgColor
        ToyImg2.layer.shadowColor = UIColor.gray.cgColor
        ToyImg2.layer.shadowRadius = 9.0
        ToyImg2.layer.shadowOpacity = 0.5
        ToyImg2.layer.shadowPath = UIBezierPath(roundedRect: ToyImg2.bounds, cornerRadius: ToyImg2.layer.cornerRadius).cgPath
        
        ToyImg2.clipsToBounds = true
        ToyImg2.layer.masksToBounds = true
        //------------------------------------------------------------
        
        
        if UserDefaults.standard.string(forKey:"_id")!  == demandList[indexPath.row].IdClient1 {
                for j in (0..<toyList.count){
                    if demandList[indexPath.row].IdToy1 == toyList[j]._id {
                        var path = String("http://localhost:3000/"+toyList[j].Image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
                        
                        let url = URL(string: path)!
                        ToyImg1.af.setImage(withURL: url)

                    }else if demandList[indexPath.row].IdToy2 == toyList[j]._id {
                        var path2 = String("http://localhost:3000/"+toyList[j].Image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        path2 = path2.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
                        
                        let url = URL(string: path2)!
                        ToyImg2.af.setImage(withURL: url)
                        
                        ToyDescription.text = "Demand to "+demandList[indexPath.row].SwapType!+" "+toyList[j].Description!
                    }
                }
            }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {
            (action, sourceView, completionHandler) in

            SwapViewModal().deleteDemand(IdDemand: self.demandList[indexPath.row]._id! , successHandler: {
                self.initalise()

            }, errorHandler: {
                self.alertMethod(titre: "warning", message: "swap would not delete !!")
            })
            
            completionHandler(true)
        } // end action Delete
        
        deleteAction.backgroundColor = UIColor(red:255.0/255.0 ,green: 100.0/255.0 ,blue: 92.0/255.0 , alpha:1.0)
        
        // SWIPE TO Left CONFIGURATION
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let demandsAction = UIContextualAction(style: .normal, title: "ScanQR") {
            (action, sourceView, completionHandler) in
            
            self.performSegue(withIdentifier: "qrSegue", sender: indexPath)
            completionHandler(true)
        }
        
        demandsAction.backgroundColor = UIColor(red:222.0/255.0 ,green: 210.0/255.0 ,blue: 238.0/255.0 , alpha:1.0)
        //shareAction.image = UIImage(named: "share")      // OPTIONAL use image instead of text
        // end action Share
        
        
        // SWIPE TO right CONFIGURATION
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [demandsAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
        
    }
    

}
