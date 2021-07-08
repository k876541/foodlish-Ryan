//
//  FoodImageCollectionViewCell.swift
//  foodlish-Ryan
//
//  Created by Ryan Chang on 2021/7/7.
//

import UIKit

class FoodImageCollectionViewCell: UICollectionViewCell {
  
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    let width = floor((UIScreen.main.bounds.width - 3*2)/3.1)
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        imageWidthConstraint.constant = self.width
        
    }
    
    
}
