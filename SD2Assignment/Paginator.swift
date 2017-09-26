//
//  Paginator.swift
//  SD2Assignment
//
//  Created by Orahi on 26/09/17.
//

import Foundation

enum PaginatorMode {
    case userData
}

class Paginator: AKSPaginator   {
    var paginationFor : PaginatorMode?
    var userInfo : NSDictionary?
    override func fetchPage(_ page:NSInteger){
        if paginationFor == PaginatorMode.userData {
            self.requestStatus = RequestStatus.requestStatusInProgress
            Dm().getUserDataForPage(pageSize: UInt(pageSize), pageNo: UInt(page), completion: { (pageNo, results , error) in
                if let _ = results {
                    super.setSuccess(results as! [Any], totalResults:10240)
                }else{
                    super.setFailure()
                }
            })
        }
    }
}

