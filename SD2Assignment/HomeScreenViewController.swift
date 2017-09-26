//
//  HomeScreenViewController.swift
//  SD2Assignment
//
//  Created by Orahi on 26/09/17.
//

import UIKit

class HomeScreenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var informationLabel : UILabel!
    fileprivate var paginationController = Paginator()

    override internal func viewDidLoad() {
        super.viewDidLoad()
        startUpInitialisations()
        registerForNotifications()
        updateUserInterfaceOnScreen()
    }
    
    private func startUpInitialisations(){
        registerNib("UserDetailsTableViewCell", tableView: tableView)
        setupForPaginationController()
        fetchFirstPage()
    }
    
    private func registerForNotifications(){
    
    }

    private func updateUserInterfaceOnScreen(){
        
    }

    func setupForPaginationController(){
        weak var weakSelf = self
        paginationController.setup(20)
        paginationController.paginationFor = PaginatorMode.userData
        paginationController.completionBlock =
            { (paginator) -> () in
                weakSelf?.tableView?.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Pagination Controller
extension HomeScreenViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if velocity < 0 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            if paginationController.reachedLastPage() == false{
                if paginationController.requestStatus == RequestStatus.requestStatusNone {
                    if scrollView == tableView && paginationController.results.count > 0 {
                        fetchNextData()
                    }else{
                        fetchFirstPage()
                    }
                }
            }
        }
    }

    func fetchNextData(){
        if paginationController.reachedLastPage() == false{
            if paginationController.requestStatus == RequestStatus.requestStatusNone {
                paginationController.fetchNextPage()
            }
        }
        tableView?.reloadData()
    }
    
    func fetchFirstPage(){
        paginationController.reset()
        paginationController.fetchFirstPage()
        tableView?.reloadData()
    }
    
}


//MARK: - UITableView Delegate & Data Source
extension HomeScreenViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paginationController.results.count > 0 {
            informationLabel.isHidden = true
        }else{
            informationLabel.isHidden = false
        }
        return paginationController.results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UserDetailsTableViewCell.getRequiredHeight(data: paginationController.results[indexPath.row] as! [String : AnyObject])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell") as! UserDetailsTableViewCell
        cell.data = paginationController.results[indexPath.row] as! [String : AnyObject]
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension HomeScreenViewController {
    func registerNib(_ nibName:String,tableView:UITableView?){
        tableView?.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}
