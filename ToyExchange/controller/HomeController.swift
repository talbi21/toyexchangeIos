//
//  HomeController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 5/11/2021.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    //var
    var allToys = [Toy]()
    var allOthersToys = [Toy]()
    
    //IBOUtlets
    @IBOutlet weak var CollectionViewHome: UICollectionView!
    
    //widgets
        //image Client
        @IBOutlet weak var IMVAvatar: UIImageView!
        @IBOutlet weak var SearchBar: UISearchBar!
    

    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.initialise()
        
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
    
    func initialise(){
        if reachability.connection == .unavailable {
            showSpinner()
            print("no wifi")
            print("no wifi")
            print("no wifi")
            print("no wifi")
        }else{
            
            IMVAvatar?.layer.cornerRadius = (IMVAvatar?.frame.size.width ?? 0.0) / 2
            IMVAvatar?.clipsToBounds = true
            IMVAvatar?.layer.borderWidth = 2.0
            IMVAvatar?.layer.borderColor = UIColor.black.cgColor

            ToyViewModal().getToys(successHandler: {anomalyList in
                self.allToys = anomalyList
                
                for i in (0..<self.allToys.count) {
                    if self.allToys[i].OwnerId != UserDefaults.standard.string(forKey:"_id") {
                        self.allOthersToys.append(self.allToys[i])
                        print(self.allOthersToys)
                    }
                }
                
                self.CollectionViewHome.reloadData()
                
            }, errorHandler: {
                self.alertMethod(titre: "warning", message: "error occured in getting list")
            })
            
            //avatar image
            var path = (Constantes.host + UserDefaults.standard.string(forKey:"_id")!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

                path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
                let url = URL(string: path)!
                IMVAvatar.af.setImage(withURL: url)
            //----------------

        }
    }

    
    //methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allOthersToys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
        "ToyCell", for: indexPath)

        let cv = cell.contentView
        let imageView = cv.viewWithTag(1) as! UIImageView
        print("------------home alltoys----------------")
        print(allOthersToys[indexPath.row])
        print("--------------end home alltoys--------------")
        print("----------------------------")
        
        var path = String("http://localhost:3000/"+(allOthersToys[indexPath.row].Image)!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        print(url)
        
        imageView.af.setImage(withURL: url)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowRadius = 9.0
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: imageView.layer.cornerRadius).cgPath
        
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
         return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toyDetailSegue", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToProfileSegue" {
            
            
        }else if segue.identifier == "toParameter" {
            
        }else if segue.identifier == "toyDetailSegue" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! ToyDetailController
            
            destination.selectedToy = allOthersToys[indexPath.row]
        }
    }
    
    //IBActions
        //btn with gear logo on click leading to app parameter
        @IBAction func BtnGoToAppParameter(_ sender: Any) {
            performSegue(withIdentifier: "toParameter", sender: sender)
        }
        
        @IBAction func BtnIVAvatar(_ sender: Any) {
            performSegue(withIdentifier: "ToProfileSegue", sender: sender)
        }
    

}
