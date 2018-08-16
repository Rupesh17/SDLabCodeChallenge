//
//  UserCollectionHeaderView.swift
//  TestApp
//
//  Created by Rupesh Kumar on 18/05/18.
//  Copyright © 2018 Rupesh Kumar. All rights reserved.
//

import UIKit

class UserCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func prepareForReuse() {
        userImageView.image = #imageLiteral(resourceName: "placeHolder.png")
        userNameLabel.text = nil
        super.prepareForReuse()
    }
}
