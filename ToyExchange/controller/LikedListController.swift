//
//  LikedListController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 5/11/2021.
//

import UIKit
import CoreData

class LikedListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //var
    var likedListName = [String]()
    var likedListImage = [String]()
    
    var likedListDescrip = [String]()
    @IBOutlet weak var TVLikedList: UITableView!
    //lifecyle
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.TVLikedList.reloadData()
        // Do any additional setup after loading the view.
        
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
        return likedListName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedListCell")
        let contentView = cell?.contentView

        let ToyImg = contentView?.viewWithTag(1) as! UIImageView
        let ToyName = contentView?.viewWithTag(2) as! UILabel
        //let ToyLocation = contentView?.viewWithTag(3) as! UILabel
        let ToyDescription = contentView?.viewWithTag(4) as! UITextView
        
        var path = String("http://localhost:3000/"+(likedListImage[indexPath.row])).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        print(url)
        ToyImg.af.setImage(withURL: url)
        
        //ToyImg.image = UIImage(named: likedListImage[indexPath.row])
        ToyName.text = likedListName[indexPath.row]
        //ToyLocation.text = likedList[indexPath.row]
        ToyDescription.text = likedListDescrip[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //film.remove(at: indexPath.row)
            deleteData(indexPath: indexPath)
            self.TVLikedList.reloadData()
        }
    }
    
    func fetchData( ){
        //recuperarion du notre appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "CoreDataToy")
       
        do{
           let result = try managedContext.fetch(request)
            for item in result{
                
                likedListName.append(item.value(forKey: "name") as! String)
                likedListImage.append(item.value(forKey: "image") as! String)
                likedListDescrip.append(item.value(forKey: "descrip") as! String)
            }
            
        }catch{
            print("fetch error")
        }
        
    }
    
    func deleteData(indexPath:IndexPath){
        //recuperarion du notre appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        //----------
        let name = likedListName[ indexPath.row ]
        let request = NSFetchRequest<NSManagedObject>(entityName: "CoreDataToy")
        let predicate = NSPredicate(format: "name = %@", name)
        request.predicate = predicate
        
        do{
            let result = try managedContext.fetch(request)
            var obj: NSManagedObject?
            for item in result {
                obj = item
            }
            managedContext.delete(obj!)
            
        }catch{
            print("delete error")
        }

        //remove from view
        likedListName.remove(at: indexPath.row)
        likedListImage.remove(at: indexPath.row)
        likedListDescrip.remove(at: indexPath.row)
        //save data
        do{
            try managedContext.save( )
            print("toy saved")
            
        }catch{
            print("add error")
        }
        
    }
    
    
}
