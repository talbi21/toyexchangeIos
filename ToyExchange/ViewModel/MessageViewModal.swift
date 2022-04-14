//
//  MessageViewModal.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 2/1/2022.
//

import Foundation
import SwiftyJSON
import Alamofire

public class MessagerieViewModel: ObservableObject{
    
    static let sharedInstance = MessagerieViewModel()
    
    func recupererMesConversations( completed: @escaping (Bool, [Conversation]?) -> Void ) {
        AF.request(Constantes.host + "Message/mes-conversations",
                   method: .post,
                   parameters: [ "envoyeur" : UserDefaults.standard.string(forKey: "_id")!],
                   
                
                   
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var conversation : [Conversation]? = []
                    for singleJsonItem in jsonData["conversations"] {
                        conversation!.append(self.makeConversation(jsonItem: singleJsonItem.1))
                    }
                    completed(true, conversation)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func creerNouvelleConversation(recepteur: String, completed: @escaping (Bool, Conversation?) -> Void ) {
        AF.request(Constantes.host + "Message/creer-conversation",
                   method: .post,
                   parameters: [
                    "envoyeur" : UserDefaults.standard.string(forKey: "_id")!,
                    "recepteur" : recepteur
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, self.makeConversation(jsonItem: JSON(response.data!)["messages"]))
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func recupererMesMessages(idConversation: String, completed: @escaping (Bool, [Message]?) -> Void ) {
        AF.request(Constantes.host + "Message/mes-messages",
                   method: .post,
                   parameters: [ "conversation" : idConversation ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var messages : [Message]? = []
                    for singleJsonItem in jsonData["messages"] {
                        messages!.append(self.makeMessage(jsonItem: singleJsonItem.1))
                    }
                    completed(true, messages)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func envoyerMessage(recepteur: String, description: String, completed: @escaping (Bool, Message?) -> Void ) {
        AF.request(Constantes.host + "Message/envoyer-message",
                   method: .post,
                   parameters: [
                    "envoyeur": UserDefaults.standard.string(forKey: "_id")!,
                    "recepteur": recepteur,
                    "description": description
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, self.makeMessage(jsonItem: JSON(response.data!)["newMessage"]))
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func makeMessage(jsonItem: JSON) -> Message {
        return Message(
            sender: Sender(senderId: jsonItem["conversationEnvoyeur"]["envoyeur"].stringValue, displayName: "abc"),
            messageId: jsonItem["_id"].stringValue,
            sentDate: Date(),
            kind: .text(jsonItem["description"].stringValue)
        )
    }
    
    func makeConversation(jsonItem: JSON) -> Conversation {
        return Conversation(
            _id: jsonItem["_id"].stringValue,
            dernierMessage: jsonItem["dernierMessage"].stringValue,
            dateDernierMessage: DateUtils.formatFromString(string: jsonItem["dateDernierMessage"].stringValue),
            envoyeur: ClientViewModal.sharedInstance.makeItem(jsonItem: jsonItem["envoyeur"]),
            recepteur: ClientViewModal.sharedInstance.makeItem(jsonItem: jsonItem["recepteur"])
        )
    }
}
