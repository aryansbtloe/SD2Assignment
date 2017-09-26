//
//  UserDetailsTableViewCell.swift
//  SD2Assignment
//
//  Created by Orahi on 26/09/17.
//

import Foundation
import UIKit

enum UDTLayoutType {
    case zeroImages
    case oneImages
    case twoImages
    case threeImages
    case fourImages
    case fiveAndMoreImages
}

class UserDetailsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var profilePictureImageView : UIImageView!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var topPictureImageView : UIImageView!
    @IBOutlet weak var otherImages1ImageView : UIImageView!
    @IBOutlet weak var otherImages2ImageView : UIImageView!
    @IBOutlet weak var otherImages3ImageView : UIImageView!
    @IBOutlet weak var otherImages4ImageView : UIImageView!
    @IBOutlet weak var tralingSpaceToSuperView : NSLayoutConstraint!

    var layout = UDTLayoutType.zeroImages
    var isInitialisedOnce = false
    var data:[String:AnyObject]?
    var indexPath:IndexPath?

    override func layoutSubviews() {
        super.layoutSubviews()
        startUpInitialisations()
        updateUserInterfaceOnScreen()
    }
    
    private func startUpInitialisations(){
        self.contentView.layoutIfNeeded()
        if isInitialisedOnce == false {
            self.selectionStyle = UITableViewCellSelectionStyle.none
            self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.bounds.size.height/2
            self.profilePictureImageView.layer.masksToBounds = true
            self.profilePictureImageView.clipsToBounds = true
            func setCornerRadius(imageView:UIImageView){
                imageView.layer.cornerRadius = 3
                imageView.layer.masksToBounds = true
                imageView.clipsToBounds = true
            }
            setCornerRadius(imageView: topPictureImageView)
            setCornerRadius(imageView: otherImages1ImageView)
            setCornerRadius(imageView: otherImages2ImageView)
            setCornerRadius(imageView: otherImages3ImageView)
            setCornerRadius(imageView: otherImages4ImageView)
        }
        isInitialisedOnce = true
    }
    
    private func updateUserInterfaceOnScreen(){
        self.layout = UserDetailsTableViewCell.layoutType(data: data!)
        if let profileImageUrl = data?["image"] as? String {
            self.profilePictureImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "userPlaceHolder"))
        }else{
            self.profilePictureImageView.image = UIImage(named: "userPlaceHolder")
        }
        if let userName = data?["name"] as? String {
            self.userNameLabel.text = userName
        }else{
            self.userNameLabel.text = "User"
        }
        updateLayoutAndItemImages()
    }
    
    func updateLayoutAndItemImages() {
        self.topPictureImageView.image = nil
        self.otherImages1ImageView.image = nil
        self.otherImages2ImageView.image = nil
        self.otherImages3ImageView.image = nil
        self.otherImages4ImageView.image = nil
        self.tralingSpaceToSuperView.constant = 0
        if self.layout == .zeroImages {
            self.topPictureImageView.isHidden = true
            self.otherImages1ImageView.isHidden = true
            self.otherImages2ImageView.isHidden = true
            self.otherImages3ImageView.isHidden = true
            self.otherImages4ImageView.isHidden = true
            self.tralingSpaceToSuperView.constant = self.bounds.size.width
        }else if self.layout == .oneImages {
            self.topPictureImageView.isHidden = false
            self.otherImages1ImageView.isHidden = true
            self.otherImages2ImageView.isHidden = true
            self.otherImages3ImageView.isHidden = true
            self.otherImages4ImageView.isHidden = true
            setImage(index: 0, imageView: topPictureImageView)
        }else if self.layout == .twoImages {
            self.topPictureImageView.isHidden = true
            self.otherImages1ImageView.isHidden = false
            self.otherImages2ImageView.isHidden = false
            self.otherImages3ImageView.isHidden = true
            self.otherImages4ImageView.isHidden = true
            setImage(index: 0, imageView: otherImages1ImageView)
            setImage(index: 1, imageView: otherImages2ImageView)
            self.tralingSpaceToSuperView.constant = self.bounds.size.width
        }else if self.layout == .threeImages {
            self.topPictureImageView.isHidden = false
            self.otherImages1ImageView.isHidden = false
            self.otherImages2ImageView.isHidden = false
            self.otherImages3ImageView.isHidden = true
            self.otherImages4ImageView.isHidden = true
            setImage(index: 0, imageView: topPictureImageView)
            setImage(index: 1, imageView: otherImages1ImageView)
            setImage(index: 2, imageView: otherImages2ImageView)
        }else if self.layout == .fourImages {
            self.topPictureImageView.isHidden = true
            self.otherImages1ImageView.isHidden = false
            self.otherImages2ImageView.isHidden = false
            self.otherImages3ImageView.isHidden = false
            self.otherImages4ImageView.isHidden = false
            setImage(index: 0, imageView: otherImages1ImageView)
            setImage(index: 1, imageView: otherImages2ImageView)
            setImage(index: 2, imageView: otherImages3ImageView)
            setImage(index: 3, imageView: otherImages4ImageView)
            self.tralingSpaceToSuperView.constant = self.bounds.size.width
        }else if self.layout == .fiveAndMoreImages {
            self.topPictureImageView.isHidden = false
            self.otherImages1ImageView.isHidden = false
            self.otherImages2ImageView.isHidden = false
            self.otherImages3ImageView.isHidden = false
            self.otherImages4ImageView.isHidden = false
            setImage(index: 0, imageView: topPictureImageView)
            setImage(index: 1, imageView: otherImages1ImageView)
            setImage(index: 2, imageView: otherImages2ImageView)
            setImage(index: 3, imageView: otherImages3ImageView)
            setImage(index: 4, imageView: otherImages4ImageView)
        }
        self.contentView.setNeedsLayout()
        self.contentView.setNeedsDisplay()
        self.contentView.layoutIfNeeded()
    }
    
    func setImage(index:Int,imageView:UIImageView) {
        if let images = data?["items"] as? [String] , images.count > index , let url = images[index] as? String {
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "noImage"))
            imageView.sd_setImage(with: URL(string: url))
        }else{
            imageView.image = UIImage(named: "noImage")
        }
    }
    
    static func layoutType(data:[String:AnyObject])->UDTLayoutType{
        if let items = data["items"] as? [String] {
            if items.count >= 5 {
                return UDTLayoutType.fiveAndMoreImages
            }else if items.count >= 4 {
                return UDTLayoutType.fourImages
            }else if items.count >= 3 {
                return UDTLayoutType.threeImages
            }else if items.count >= 2 {
                return UDTLayoutType.twoImages
            }else if items.count >= 1 {
                return UDTLayoutType.oneImages
            }else{
                return UDTLayoutType.zeroImages
            }
        }
        return UDTLayoutType.zeroImages
    }
    
    static func getRequiredHeight(data:[String:AnyObject])->CGFloat{
        let w = UIScreen.main.bounds.width - 20
        let layout = UserDetailsTableViewCell.layoutType(data: data)
        if layout == .zeroImages {
            return 121.0
        }else if layout == .oneImages {
            return 121.0 + 10 + w + 10
        }else if layout == .twoImages {
            return 121.0 + 10 + (w - 10)/2 + 10
        }else if layout == .threeImages {
            return 121.0 + 10 + w + 10 + (w - 10)/2 + 10
        }else if layout == .fourImages {
            return 121.0 + 10 + (w - 10)/2 + 10 + (w - 10)/2 + 10
        }else if layout == .fiveAndMoreImages {
            return 121.0 + 10 + w + 10 + (w - 10)/2 + 10 + (w - 10)/2 + 10
        }
        return 121.0
    }
    
}
