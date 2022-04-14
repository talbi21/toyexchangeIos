//
//  ProfileController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 5/11/2021.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    //var
    var clientVM = ClientViewModal()
    var toyVm = ToyViewModal()
    var allToys = [Toy]()
    var userToys = [Toy]()
    //widgets

    @IBOutlet weak var IMVProfileImage: UIImageView!
    @IBOutlet weak var LabelUserName: UILabel!
    @IBOutlet weak var LabelLocation: UILabel!
    @IBOutlet weak var LabelEmail: UILabel!
    @IBOutlet weak var LabelPhoneNumber: UILabel!
    
    @IBOutlet weak var TBMyToys: UITableView!
     
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelUserName.text = UserDefaults.standard.string(forKey:"userName")!
        LabelEmail.text = UserDefaults.standard.string(forKey:"email")!
        LabelPhoneNumber.text = UserDefaults.standard.string(forKey:"phoneNumber")!

        IMVProfileImage?.layer.cornerRadius = (IMVProfileImage?.frame.size.width ?? 0.0) / 2
        IMVProfileImage?.clipsToBounds = true
        IMVProfileImage?.layer.borderWidth = 2.0
        IMVProfileImage?.layer.borderColor = UIColor.black.cgColor

        self.intialise()
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
    }

    func intialise(){
        
        var path = String("http://localhost:3000/"+UserDefaults.standard.string(forKey:"image")!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

             path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
              let url = URL(string: path)!
              print(url)
            IMVProfileImage.af.setImage(withURL: url)
        
        ToyViewModal().getToys(successHandler: {anomalyList in
            self.allToys = anomalyList
            
            for i in (0..<self.allToys.count) {
                if self.allToys[i].OwnerId == UserDefaults.standard.string(forKey:"_id")! {
                    self.userToys.append(self.allToys[i])
                }
            }
            
            self.TBMyToys.reloadData()
            
        }, errorHandler: {
            self.alertMethod(titre: "warning", message: "error occured in getting list")
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
    
    //IBctions
    @IBAction func UpdateProfileAction(_ sender: Any) {
        performSegue(withIdentifier: "toProfileModificationSegue", sender: sender)
    }
    
    @IBAction func LogOutAction(_ sender: Any) {
        clientVM.signout()
        
    }
    
    //methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileModificationSegue"{
            
        }else if segue.identifier == "modifyToySegue" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! PostModificationController
            destination.selectedToy = userToys[indexPath.row]
 
        }else if segue.identifier == "ToShowDemandsSegue" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! PostDemandListController
            destination.selectedToy = userToys[indexPath.row]
 
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userToys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier:"myToyCell")
        //if allToys[indexPath.row]._id! == (self.clientVM.ClientToken?.id)!{
        
            let contentView = cell?.contentView
            let toyImg = contentView?.viewWithTag(1) as! UIImageView
            let toyName = contentView?.viewWithTag(2) as! UILabel
            let toyDescription = contentView?.viewWithTag(3) as! UITextView
        
        var path = String("http://localhost:3000/"+(userToys[indexPath.row].Image)!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        toyImg.af.setImage(withURL: url)
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
            
            //toyImg.image = UIImage(named: allToys[indexPath.row].Image!)
            toyName.text = userToys[indexPath.row].Name!
            toyDescription.text = userToys[indexPath.row].Description!
            
        //}
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                //*********** DELETE (.destructive = red color) ***********
                let deleteAction = UIContextualAction(style: .normal, title: "Delete") {
                    (action, sourceView, completionHandler) in

                    //let book = self.allToys[(indexPath as NSIndexPath).row] as Toy
                    // Delete the book and associated records
                    ToyViewModal().deleteToy(toyId: self.userToys[indexPath.row]._id!, successHandler: {anomalyList in
                        self.alertMethod(titre: "success", message: "deleted successfully !")
                        self.intialise()
                    }, errorHandler: {
                        self.alertMethod(titre: "warning", message: "deleted goes rong !")
                    })
                    self.TBMyToys.reloadData()
                    // Remove the menu option from the screen
                    completionHandler(true)
                } // end action Delete
                
        deleteAction.backgroundColor = UIColor(red:255.0/255.0 ,green: 100.0/255.0 ,blue: 92.0/255.0 , alpha:1.0)
                // *********** EDIT ***********
                let editAction = UIContextualAction(style: .normal, title: "Edit") {
                    (action, sourceView, completionHandler) in
                    // 1. Segue to Edit view MUST PASS INDEX PATH as Sender to the prepareSegue function
                    self.performSegue(withIdentifier: "modifyToySegue", sender: indexPath)
                    completionHandler(true)
                    
                }
                
        editAction.backgroundColor = UIColor(red:222.0/255.0 ,green: 210.0/255.0 ,blue: 238.0/255.0 , alpha:1.0)
        
                // end action Edit
        
        // *********** Demands ***********
        let demandsAction = UIContextualAction(style: .normal, title: "Demands") {
            (action, sourceView, completionHandler) in
            
            //let book = self.books[(indexPath as NSIndexPath).row] as Book
            //self.swipeShareAction(book, indexPath: indexPath)
            self.performSegue(withIdentifier: "ToShowDemandsSegue", sender: indexPath)
            
            completionHandler(true)        // removes the menu option from the screen
            
        }
        
        demandsAction.backgroundColor = UIColor(red:173.0/255.0 ,green: 213.0/255.0 ,blue:  255.0/255.0,alpha:  1)
        //shareAction.image = UIImage(named: "share")      // OPTIONAL use image instead of text
        // end action Share
        
        
        // SWIPE TO LEFT CONFIGURATION
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction,demandsAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
                
    }
    
    
}
