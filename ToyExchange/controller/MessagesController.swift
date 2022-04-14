//
//  MessagesController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 7/11/2021.
//

import UIKit

class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource, ModalTransitionListener {
    
    private var conversations : [Conversation] = []
    private var selectedConversation: Conversation?
    
    
    
    @IBOutlet weak var ContactTable: UITableView!
    @IBOutlet weak var LabelTitle: UILabel!
    
    @IBOutlet weak var LabelPlus: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contentView = cell?.contentView

        let imageProfile = contentView?.viewWithTag(1) as! UIImageView
        let labelUsername = contentView?.viewWithTag(2) as! UILabel
        let labellastMessage = contentView?.viewWithTag(3) as! UILabel
        
        
        
        let conversation = conversations[indexPath.row]
        let recepteur = conversation.recepteur
        
        var path = String(Constantes.host + (conversations[indexPath.row].recepteur.image)!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
        
        let url = URL(string: path)!
        print(url)
        imageProfile.af.setImage(withURL: url)
        
        labelUsername.text = recepteur.userName!
        labellastMessage.text = conversation.dernierMessage
        
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            /*ConversationViewModel().supprimerConversation(_id: conversations[indexPath.row]._id) { success in
                if success {
                    print("deleted chat")
                    self.conversations.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                    print("error while deleting chat")
                }
            }*/
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedConversation = conversations[indexPath.row]
        self.performSegue(withIdentifier: "conversationSegue", sender: selectedConversation)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModalTransitionMediator.instance.setListener(listener: self)

    }


//methods

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "conversationSegue" {
        let destination = segue.destination as! ChatController
        destination.currentConversation = selectedConversation
        //callback onchoose function to get the selected row data
        //assign to function
       // destination.onChoose = onChoose
        
    }
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
    
    func popoverDismissed() {
        initialize()
    }
    
    func initialize() {
        MessagerieViewModel.sharedInstance.recupererMesConversations { success, conversationsfromRep in
            if success {
                self.conversations = conversationsfromRep!
                self.ContactTable.reloadData()
            }else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load conversations "),animated: true)

            }
        }
    }
    
}
