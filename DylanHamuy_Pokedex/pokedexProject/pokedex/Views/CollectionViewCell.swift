//
//  CollectionViewCell.swift
//  pokedex
//
//  Created by Dylan Hamuy on 10/17/21.
//  Copyright © 2021 Dylan Hamuy. All rights reserved.
//


import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    func configurePFP(with imageURL: String) {
        guard let imageUrl:URL = URL(string: imageURL) else {
            return
        }
        profilePic.loadImage(withUrl: imageUrl)
    }
}

extension UIImageView {
    func loadImage(withUrl url: URL) {
        DispatchQueue.global().async{ [weak self] in
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    }
}
