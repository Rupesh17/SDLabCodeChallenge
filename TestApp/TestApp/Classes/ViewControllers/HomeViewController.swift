//
//  HomeViewController.swift
//  TestApp
//
//  Created by Rupesh Kumar on 18/05/18.
//  Copyright © 2018 Rupesh Kumar. All rights reserved.
//

import UIKit
import SDWebImage

let kSectionLeftRightMargin:CGFloat = 10
let kSectionTopBottomMargin:CGFloat = 10

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    var userList = Array<User>()
    var isGettingMoreUser = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMoreUsers()
    }
    
    private func fetchMoreUsers() {
        if isGettingMoreUser { return }
        isGettingMoreUser = true
        WebServiceManager().getUserList(from: self.userList.count, limit: kBatchFetchLimit)  {[weak self] newUserList in
            self?.userList.append(contentsOf: newUserList!)
            DispatchQueue.main.async {
                self?.userCollectionView.reloadData()
                self?.isGettingMoreUser = false
            }
        }
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList[section].userItemList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: kUserCollectionViewCellID, for: indexPath) as! UserItemCollectionCell
        
        let user = userList[indexPath.section]
        let imageName = user.userItemList[indexPath.row]
        if let url = URL(string: imageName) {
            //Image Cache using SDWebImage
            cell.userItemImageView.sd_setShowActivityIndicatorView(true)
            cell.userItemImageView.sd_setIndicatorStyle(.gray)
            cell.userItemImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeHolder.png"), options: SDWebImageOptions.delayPlaceholder, completed: nil)
        }
        
        if (userList.count - indexPath.section <= 2) {
            fetchMoreUsers()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind
        {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind:
                    kind, withReuseIdentifier: kUserCollectionHeaderViewID, for: indexPath) as! UserCollectionHeaderView
                
                let user = userList[indexPath.section]
                headerView.userNameLabel.text = user.name
                
                if let userImagePath = user.imageUrl {
                    if let url = URL(string: userImagePath) {
                        //Image Cache using SDWebImage
                        headerView.userImageView.sd_setShowActivityIndicatorView(true)
                        headerView.userImageView.sd_setIndicatorStyle(.gray)
                        headerView.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeHolder.png"), options: SDWebImageOptions.delayPlaceholder, completed: nil)
                    }
                }
                
                headerView.userImageView.layer.cornerRadius = headerView.userImageView.bounds.width/2

                return headerView
            
            default:
                assert(false, "Unexpected element kind")
        }
    }
    

    //MARK: Flow Layout for odd even with eql sapcing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Equal width and height
        var width = collectionView.bounds.size.width - 2*kSectionLeftRightMargin
        var height = collectionView.bounds.size.width - 2*kSectionTopBottomMargin

        let user = userList[indexPath.section]
        if !(indexPath.row == 0 && user.userItemList.count % 2 != 0){
            width = (width - kSectionLeftRightMargin) / 2
            height = (height - kSectionTopBottomMargin) / 2
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kSectionLeftRightMargin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: kSectionTopBottomMargin, left: kSectionLeftRightMargin, bottom: kSectionTopBottomMargin, right: kSectionLeftRightMargin)
    }
}
