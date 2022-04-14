//
//  ClientModel.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 10/11/2021.
//

import Foundation

struct ClientsData : Decodable{
    
    let clients : [Client]?
    
      enum CodingKeys: String, CodingKey {
          case clients = "clients"
       }
}

struct Client :Decodable{
    var _id:String?
    var userName: String?
    var email: String?
    var password: String?
    var phoneNumber: String?
    var image: String?
    
      enum CodingKeys: String, CodingKey {
          case _id,userName, email,password,phoneNumber,image
       }
}
