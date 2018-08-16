//
//  UserTableViewCell.swift
//  TestApp
//
//  Created by Rupesh Kumar on 18/05/18.
//  Copyright © 2018 Rupesh Kumar. All rights reserved.
//

import UIKit

class UserItemCollectionCell: UICollectionViewCell {

    @IBOutlet weak var userItemImageView: UIImageView!
    
    override func prepareForReuse() {
        userItemImageView.image = #imageLiteral(resourceName: "placeHolder.png")
        super.prepareForReuse()
    }
}
