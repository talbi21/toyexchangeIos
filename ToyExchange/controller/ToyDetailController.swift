//
//  ToyDetailController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 6/11/2021.
//

import UIKit
import CoreData

class ToyDetailController: UIViewController {
    
    //var
    var selectedToy : Toy?
    
    //IBOutlets
    @IBOutlet weak var LabelToyName: UILabel!
    @IBOutlet weak var TextViewDescription: UITextView!
    @IBOutlet weak var LabelPrice: UILabel!
    @IBOutlet weak var IMVToy: UIImageView!

    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        LabelToyName.text = selectedToy!.Name!
        LabelPrice.text = "$ "+selectedToy!.Price!
        TextViewDescription.text = selectedToy!.Description!
        
        var path = String("http://localhost:3000/"+selectedToy!.Image!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        print(url)
        IMVToy.af.setImage(withURL: url)
        
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
    @IBAction func BookMarkAction(_ sender: Any) {
        if !checkMovies(){
            addToLikedList()
        }else{
            let alert = UIAlertController(title: "Warinig ", message: "Toy already marked", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func BtnDemandAction(_ sender: Any) {
        performSegue(withIdentifier: "demandSegue", sender: sender)
    }
    
    //methods
    
    func addToLikedList(){
        //recuperarion du notre appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        //description de l'entite
        let entityDescription = NSEntityDescription.entity(forEntityName: "CoreDataToy", in: managedContext)
        
        //creation d'un nouveau object
        let object = NSManagedObject(entity: entityDescription!, insertInto: managedContext)
        //set value to object
        object.setValue(selectedToy!.Name!, forKey: "name")
        object.setValue(selectedToy!.Image!, forKey: "image")
        object.setValue(selectedToy!.Description!, forKey: "descrip")
        //save data
        do{
            try managedContext.save( )
            print("TOY saved")
            
        }catch{
            print("add error")
        }
    }
    
    func checkMovies( ) -> Bool {
        //recuperarion du notre appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "CoreDataToy")
        let predicate = NSPredicate(format: "name = %@", selectedToy!.Name!)
        
        request.predicate = predicate
        
        do{
           let result = try managedContext.fetch(request)
            if(result.count > 0){
                return true
            }
        }catch{
            print("fetch error")
        }
        return false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "demandSegue"{
            let destination = segue.destination as! SwapDemandController
            destination.toyToDemand = selectedToy
        }
    }
    
}
