//
//  PhotoCell.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 29/09/2022.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Properties
    var representedAssetIdentifier: String!

    // MARK: Life cycle
    override func prepareForReuse() {
      super.prepareForReuse()
      imageView.image = nil
    }

    // MARK: Functions
    func flash() {
      imageView.alpha = 0
      setNeedsDisplay()
      UIView.animate(withDuration: 0.5, animations: { [weak self] in
        self?.imageView.alpha = 1
      })
    }

}
