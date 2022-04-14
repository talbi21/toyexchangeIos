//
//  ContactController.swift
//  ToyExchange
//
//  Created by Apple Esprit on 27/12/2021.
//

import UIKit
import Alamofire

class ContactController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // VARS
    private var utilisateurs : [Client] = []
     
    // WIDGETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var LabelTitle: UILabel!
    
    // PROTOCOLS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utilisateurs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.contentView

        let imageProfile = contentView?.viewWithTag(1) as! UIImageView
        let labelName = contentView?.viewWithTag(2) as! UILabel
        
        
        let utilisateur = utilisateurs[indexPath.row]
        
        labelName.text = utilisateur.userName!
        
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
        imageProfile.clipsToBounds = true
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.borderWidth = 2.0
        
        var path = String(Constantes.host + (utilisateurs[indexPath.row].image)!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        print(url)
        imageProfile.af.setImage(withURL: url)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MessagerieViewModel.sharedInstance.creerNouvelleConversation(recepteur: utilisateurs[indexPath.row]._id!) { success, Conversation in
            if (success) {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.present(Alert.makeServerErrorAlert(), animated: true)
            }
        }
    }
    
    // LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialize()
        
            let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
        
            if (IsDark == true){
                overrideUserInterfaceStyle = .dark

            }else{
                overrideUserInterfaceStyle = .light
               
            }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // METHODS
    func initialize() {
       ClientViewModal.sharedInstance.recupererToutUtilisateur() { success, utilisateursfromRep in
            if success {
                self.utilisateurs = utilisateursfromRep!
                self.tableView.reloadData()
            }else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load utilisateurs "),animated: true)

            }
        }
        
    }

}
