//
//  SwapViewController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 13/12/2021.
//

import Foundation
import Alamofire

class SwapViewModal{
    
    static let shared: SwapViewModal = {
            let instance = SwapViewModal()
            return instance
        }()
    
    //-------------------------------------------------------------------------------------
    func getDemandsByToy(toyId:String, successHandler: @escaping (_ anomalyList: [Swap]) -> (),errorHandler: @escaping () -> ())
    {
        let url = (Constantes.host + "Swap/demandByToy/"+toyId)
        print("getdemandbytoy : "+url)
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Swap].self, decoder: JSONDecoder()) { apiResponse in
            guard apiResponse.response != nil else{
                errorHandler()
                return
            }
            
            switch apiResponse.response?.statusCode {
                
                case 200:
                successHandler(try! apiResponse.result.get())

                case 500:
                errorHandler()
           
            default:
              errorHandler()
                
            }
            
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func demandByClient1(IdClient1:String, successHandler: @escaping (_ anomalyList: [Swap]) -> (),errorHandler: @escaping () -> ())
    {
        let url = ( Constantes.host + "Swap/demandByClient/"+IdClient1)
        print("getdemandbyclient1 : "+url)
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Swap].self, decoder: JSONDecoder()) { apiResponse in
            guard apiResponse.response != nil else{
                errorHandler()
                return
            }
            
            switch apiResponse.response?.statusCode {
                
                case 200:
                successHandler(try! apiResponse.result.get())

                case 500:
                errorHandler()
           
            default:
              errorHandler()
                
            }
            
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    //alomofire add
        func addSwapDemand(swapDemand:Swap?,successHandler: @escaping () -> (),errorHandler: @escaping () -> (),noResponseHandler: @escaping () -> ())
        {
            let urlApi = (Constantes.host + "Swap/add")
            var parameters = ["":""]
            
            if let Vdemand = swapDemand
            {
                    parameters = ["IdClient1":Vdemand.IdClient1!,"IdClient2":Vdemand.IdClient2!,"IdToy1":Vdemand.IdToy1!,"IdToy2":Vdemand.IdToy2!,"Confirmed":Vdemand.Confirmed!,"SwapType":"swap"]
                    print("parameters swap begin ---------")
                    print(parameters )
                    print("parameters swap end ---------" )
            }
            
            AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
                        
                    guard apiResponse.response != nil else{
                        noResponseHandler()
                        return
                    }
            
                    switch apiResponse.response?.statusCode {
                        case 200:
                            successHandler()
                        case 500:
                            errorHandler()
                    default:
                        print("error")
                        errorHandler()
                    }
            }
            
        }

    //-------------------------------------------------------------------------------------------------------------------------
    func addBuyDemand(buyDemand:Swap?,successHandler: @escaping () -> (),errorHandler: @escaping () -> (),noResponseHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Swap/add")
        var parameters = ["":""]
        
        if let VbuyDemand = buyDemand
        {
            parameters = ["IdClient1":VbuyDemand.IdClient1!,"IdClient2":VbuyDemand.IdClient2!,"IdToy2":VbuyDemand.IdToy2!,"Confirmed":VbuyDemand.Confirmed!,"SwapType":"buy"]
        }
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
                    
                guard apiResponse.response != nil else{
                    noResponseHandler()
                    return
                }
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler()
                        print("case 200 --------------")
                    case 500:
                        print("case 400 --------------")
                        errorHandler()
                default:
                    print("deafault --------------")
                    //print(apiResponse.response?.statusCode)
                    errorHandler()
                }
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func deleteDemand(IdDemand:String, successHandler: @escaping () -> (),errorHandler: @escaping () -> ())
    {
        let url = (Constantes.host + "Swap/delete/"+IdDemand)
        print("delete demand url  : "+url)
        
        AF.request(url, method: .delete).response { apiResponse in
            guard apiResponse.response != nil else{
                errorHandler()
                return
            }
            
            switch apiResponse.response?.statusCode {
                
                case 200:
                successHandler()

                case 500:
                errorHandler()
           
            default:
              errorHandler()
                
            }
            
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func acceptDemand(SwapID:String?,Confirmed:Bool?,successHandler: @escaping () -> (),errorHandler: @escaping () -> (),noResponseHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Swap/update/"+SwapID!)
        //let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Content-Disposition" : "form-data"]
        let parameters = ["Confirmed":Confirmed]
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
                    
                guard apiResponse.response != nil else{
                    noResponseHandler()
                    return
                }
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler()
                        print("case 200 --------------")
                    case 500:
                        print("case 400 --------------")
                        errorHandler()
                default:
                    print("deafault --------------")
                    //print(apiResponse.response?.statusCode)
                    errorHandler()
                }
        }
        
    }
    
}
