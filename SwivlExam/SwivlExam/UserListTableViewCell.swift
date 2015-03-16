//
//  UserListTableViewCell.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/15/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import UIKit


protocol UserAvatarClickProtocol: class{
    func clickOn(user:User)
}


class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var _avatarImageView: UIImageView!
    
    @IBOutlet weak var _loginLabel: UILabel!
    
    @IBOutlet weak var _profileUrlLabel: UILabel!
    
    var _userData:User?
    
    weak var imageTapDelegate: UserAvatarClickProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let recognizer = UITapGestureRecognizer(target: self, action: "onImageTap:")
        _avatarImageView.addGestureRecognizer(recognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _avatarImageView.swl_cancelImageLoading()
        _avatarImageView.image = nil
    }
    
    func setupWithUserData(userData:User) {
        _loginLabel.text = "Login: " + userData.login
        _profileUrlLabel.text = userData.htmlUrl
        
        _avatarImageView.swl_setAvatarImageFromUrl(userData.avatarUrl)
        
        _userData = userData
    }
    
    //MARK: recognizer 
    
    func onImageTap(recognizer:UITapGestureRecognizer) {
        imageTapDelegate?.clickOn(_userData!)
    }
}
