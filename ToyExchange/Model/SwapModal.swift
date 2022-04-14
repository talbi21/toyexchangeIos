//
//  SwapModal.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 10/11/2021.
//

import Foundation

struct SwapsData :Decodable {
    let swaps : [Swap]?
    
      enum CodingKeys: String, CodingKey {
          case swaps = "swaps"
       }
}

struct Swap:Decodable{
    var _id:String?
    var IdToy1:String?
    var IdToy2:String?
    var IdClient1:String?
    var IdClient2:String?
    var Confirmed:String?
    var SwapType:String?
}

enum CodingKeys: String, CodingKey {
    case _id,IdToy1,IdToy2,IdClient1,IdClient2,Confirmed,SwapType
 }
