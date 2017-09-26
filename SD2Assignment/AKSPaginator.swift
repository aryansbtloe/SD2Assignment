//
//  AKSPaginator.swift
//  SD2Assignment
//
//  Created by Orahi on 26/09/17.
//

import Foundation

enum RequestStatus {
    case requestStatusNone
    case requestStatusInProgress
}

//MARK: - Completion block
typealias Completion = (_ paginator:Any) ->()

func paginatorDidFailToRespond(_ paginator: Any){
    
}

class AKSPaginator : NSObject  {
    var pageSize : NSInteger = -1
    var page : NSInteger = -1
    var total : NSInteger = -1
    var results : NSMutableArray = []
    var responseData : NSDictionary?
    var requestStatus : RequestStatus = RequestStatus.requestStatusNone
    var completionBlock: Completion?
    
    func setup(_ pageSize:NSInteger){
        self.pageSize = pageSize
    }
    
    func reset(){
        self.page = 0
        self.results.removeAllObjects()
        self.total = -1
        requestStatus = RequestStatus.requestStatusNone
    }
    
    func fetchFirstPage(){
        reset()
        requestStatus = RequestStatus.requestStatusInProgress
        fetchPage(1)
    }
    
    func fetchNextPage(){
        requestStatus = RequestStatus.requestStatusInProgress
        fetchPage(page+1)
    }
    
    func fetchPage(_ page:NSInteger){ //overide this method
    }
    
    func reachedLastPage()->(Bool){
        if (total != -1)&&(total <= page) {
            return true
        }
        return false
    }
    
    func setSuccess(_ results:[Any],totalResults:NSInteger){
        if results != nil && results.count > 0 {
            page += 1
            self.results.addObjects(from: results)
        }
        requestStatus = RequestStatus.requestStatusNone
        if completionBlock != nil {
            completionBlock!(self)
        }
        total = totalResults
    }
    func setFailure(){
        requestStatus = RequestStatus.requestStatusNone
        if completionBlock != nil {
            completionBlock!(self)
        }
    }
}
