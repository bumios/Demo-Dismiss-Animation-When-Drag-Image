//
//  ImageTableCell.swift
//  DemoPanImageAnimate
//
//  Created by Duy Tran N. on 2/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {

    @IBOutlet private weak var itemImageView: UIImageView!

    /// Get frame from UIImageView
    func imageViewFrame() -> CGRect {
        return itemImageView.frame
    }
}
