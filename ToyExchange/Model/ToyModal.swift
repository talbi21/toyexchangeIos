//
//  ToyModal.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 10/11/2021.
//
import Foundation

struct ToysData :Decodable {
    let toys : [Toy]?
    
      enum CodingKeys: String, CodingKey {
          case toys = "toys"
       }
}

struct Toy  :Decodable {
    var _id:String?
    var Name:String?
    var Description: String?
    var Size:String?
    var Price: String?
    var Image:String?
    var OwnerId:String?
    
    enum CodingKeys: String, CodingKey {
        case _id,Name,Description,Size,Price,Image,OwnerId
     }
}


