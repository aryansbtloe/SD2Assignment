//
//  DataManager.swift
//  SD2Assignment
//
//  Created by Orahi on 26/09/17.
//

import Foundation
import CoreLocation

func Dm()->DataManager{
    return DataManager.sharedInstance
}

typealias DMCompletion = (_ pageNo:UInt,_ results:[[String:AnyObject]]?,_ error:Error?) ->()

class DataManager: NSObject {
    
    /// initialize instance
    static let sharedInstance : DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    func getUserDataForPage(pageSize:UInt,pageNo:UInt,completion:@escaping DMCompletion){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
            let baseUrl = "http://sd2-hiring.herokuapp.com/api/users?"
            let queryParameters = "offset=\((pageNo-1)*pageSize)&limit=\(pageSize)"
            let url = URL(string: baseUrl + queryParameters)
            let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if(error != nil){
                    OperationQueue.main.addOperation({
                        completion(pageNo,nil,error)
                    })
                }else{
                    do{
                        if let responseData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? AnyObject {
                            if let results = responseData.value(forKeyPath: "data.users") as? [[String:AnyObject]] {
                                OperationQueue.main.addOperation({
                                    completion(pageNo,results,nil)
                                })
                            }
                        }
                    }catch let error {
                        OperationQueue.main.addOperation({
                            completion(pageNo,nil,error)
                        })
                    }
                }
            })
            dataTask.resume()
        })
    }
    
}

