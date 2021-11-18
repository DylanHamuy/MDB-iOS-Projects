//
//  DetailViewController.swift
//  MDB Social
//
//  Created by Dylan Hamuy on 11/13/21.
//
import UIKit

class DetailViewController: UIViewController {

    var event: SOCEvent?{
        didSet{
            if let event = event {
                nameLabel.text = event.name
                creatorLabel.text = event.creator
                descriptionLabel.text = event.description
                numLabel.text = "\(event.rsvpUsers.count)"
                urlString = event.photoURL
            }
        }
    }
    
    var creatorLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var urlString : String = ""
    
    var eventImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 15
        return image
    }()
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)!
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var numLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 25)!
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    var rsvpButton : UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitle("RSVP", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rsvpPressed), for: .touchUpInside)
        return button
    }()
    
    var deleteButton : UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
        
        nameLabel.frame = CGRect(x: 35, y: 320, width: 100, height: 40)
        view.addSubview(nameLabel)
        
        eventImage.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 200)
        view.addSubview(eventImage)
        
        numLabel.frame = CGRect(x: 150, y: 320, width: 50, height: 40)
        view.addSubview(numLabel)
        
        descriptionLabel.frame = CGRect(x: 35, y: 380, width: view.frame.width-70, height: 150)
        view.addSubview(descriptionLabel)
        
        creatorLabel.frame = CGRect(x: 35, y: 540, width: 300, height: 40)
        view.addSubview(creatorLabel)
        
        rsvpButton.frame = CGRect(x: 35, y: 590, width: 80, height: 80)
        view.addSubview(rsvpButton)
        
        guard let uid = SOCAuthManager.shared.currentUser?.uid else { return }
        guard let creator = event?.creator else { return }
        if uid == creator {
            deleteButton.frame = CGRect(x: 130, y: 590, width: 80, height: 80)
            view.addSubview(deleteButton)
        }
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
    
    @objc func rsvpPressed(){
        if rsvpButton.currentTitle == "rsvp" {
            rsvpButton.setTitle("Cancel", for: .normal)
            guard let uid = SOCAuthManager.shared.currentUser?.uid else { return }
            event?.rsvpUsers.append(uid)
            
        } else{
            rsvpButton.setTitle("rsvp", for: .normal)
            guard let uid = SOCAuthManager.shared.currentUser?.uid else { return }
            if let index = event?.rsvpUsers.firstIndex(of: uid) {
                event?.rsvpUsers.remove(at: index)
            }
        }
        guard let eventId = event?.id else { return }
        FIRDatabaseRequest.shared.db.collection("events").document(eventId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        guard let trueEvent = event else { return }
        FIRDatabaseRequest.shared.setEvent(trueEvent) {
            print("Document updated successfully")
        }
    }
    
    @objc func deletePressed(){
        deleteButton.isUserInteractionEnabled = false
        guard let eventId = event?.id else { return }
        FIRDatabaseRequest.shared.db.collection("events").document(eventId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

