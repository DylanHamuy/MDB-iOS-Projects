//
//  FeedVCCell.swift
//  MDB Social
//
//  Created by Dylan Hamuy on 11/5/21.
//

import UIKit

class FeedVCCell: UITableViewCell {
    var event: SOCEvent?{
        didSet{
            if let event = event {
                nameLabel.text = event.name
                descriptionLabel.text = event.description
                numLabel.text = "\(event.rsvpUsers.count)"
                urlString = event.photoURL
            }
        }
    }
    

    var urlString : String = ""
    
    var eventImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 15
        return image
    }()
    
    var tintView : UIView = {
        let tinted = UIView()
        tinted.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return tinted
    }()
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.3
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var numLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 25)!
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func initCellFrom(size: CGSize) {
        
        fetchImage()
        
        eventImage.frame = CGRect(x: 0, y: 10, width: size.width, height: size.height-30)
        contentView.addSubview(eventImage)
        
        tintView.frame = eventImage.frame
        contentView.addSubview(tintView)
        
        nameLabel.frame = CGRect(x: 10, y: size.height-80, width: size.width - 20, height: 40)
        contentView.addSubview(nameLabel)
        
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.frame.maxY-70, width: size.width - 20, height: 30)
        contentView.addSubview(descriptionLabel)
        
        numLabel.frame = CGRect(x: 0, y: 10, width: 50, height: 50)
        contentView.addSubview(numLabel)
    }
    func fetchImage(){
        guard let url = URL(string: urlString) else {
            return
        }
        let getDataTask = URLSession.shared.dataTask(with: url)  { data, _, _ in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.eventImage.image = image
            }
        }
        getDataTask.resume()
    }
}
 
