//
//  UserListTableViewController.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/15/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController, UserAvatarClickProtocol {

    var _userList:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.hidesWhenStopped = true
        
        self.tableView.backgroundView = activityIndicator
        activityIndicator.center = self.tableView.center
        activityIndicator.startAnimating()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            NetworkManager.sharedInstance.downloadObject(User.self, handler: { (success, data, error) -> Void in
            if success {
                self.title = "GitHub Users"
                self._userList = data as [User]
                self.tableView.reloadData()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        })
    }
    
    func clickOn(user: User) {
        println("clicked on:\(user)")
    }
}


//MARK: tableView 
extension UserListTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _userList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userListCellReuseId") as UserListTableViewCell
        configureCell(cell, userData: _userList[indexPath.row])
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 106
    }
    
    func configureCell(cell:UserListTableViewCell, userData:User) {
        cell.setupWithUserData(userData)
        cell.imageTapDelegate = self
    }
}