//
//  MaterialModal.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 10/11/2021.
//

import Foundation

struct Conversation {
    
    internal init(_id: String? = nil, dernierMessage: String, dateDernierMessage: Date, envoyeur: Client, recepteur: Client) {
        self._id = _id
        self.dernierMessage = dernierMessage
        self.dateDernierMessage = dateDernierMessage
        self.envoyeur = envoyeur
        self.recepteur = recepteur
    }
    
    var _id : String?
    var dernierMessage : String
    var dateDernierMessage : Date
    
    // relations
    var envoyeur : Client
    var recepteur : Client
}
