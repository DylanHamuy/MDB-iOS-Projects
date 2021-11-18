//
//  CreateViewController.swift
//  MDB Social
//
//  Created by Dylan Hamuy on 11/13/21.
//

import UIKit
import Firebase
import NotificationBannerSwift
import FirebaseStorage

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedDate: Date?
    var finalImage: String?
    var globalJPEG : Data?
    var globalImage : String?

    
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    var photoButton : UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitle("Upload Photo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = true
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadPressed), for: .touchUpInside)
        return button
    }()
    
    var eventNameTextField : UITextField = {
        let field = UITextField()
        field.placeholder = "Enter event name"
        field.borderStyle = UITextField.BorderStyle.line
        return field
    }()
    
    var eventDescriptionTextView : UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    var submitButton : UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = true
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        return button
    }()
    
    
    private let datePicker: UIDatePicker =  {
        let dp = UIDatePicker()
        dp.addTarget(self, action: #selector(didCreateDate), for: .valueChanged)
//        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Create Event"
        
        photoButton.frame = CGRect(x: 35, y: 100, width: 150, height: 50)
        view.addSubview(photoButton)
        
        eventNameTextField.frame = CGRect(x: 35, y: 170, width: view.frame.width-70 , height: 50)
        view.addSubview(eventNameTextField)
        
        eventDescriptionTextView.frame = CGRect(x: 35, y: 250, width: view.frame.width-70, height: 150)
        view.addSubview(eventDescriptionTextView)
        
        submitButton.frame = CGRect(x: 35, y: 590, width: 150, height: 50)
        view.addSubview(submitButton)
        
        datePicker.frame = CGRect(x: 35, y: 420, width: view.frame.width, height: 100)
        view.addSubview(datePicker)
    }
    
    
    @objc func didCreateDate(){
        let d: Date = datePicker.date
        selectedDate = d
    }
    
    @objc func submitPressed(){
        
        if eventDescriptionTextView.text.count > 140 {
            showErrorBanner(withTitle: "Too many characters", subtitle: "Limit is 140")
            
        }else if selectedDate == nil {
            showErrorBanner(withTitle: "Missing event date", subtitle: "Please select a date")
            
        }else if  globalJPEG == nil {
            showErrorBanner(withTitle: "Missing photo", subtitle: "Please upload a photo")
            
        } else{
            if eventNameTextField.text == "" {

            } else{

            }
            if eventDescriptionTextView.text == "" {

            } else{

            }
            
            guard let trueImage = globalImage else { return  }
            guard let trueJPEG = globalJPEG else { return }
            guard let uid = SOCAuthManager.shared.currentUser?.uid else { return }
            guard let trueName = eventNameTextField.text else { return }
            guard let trueDescription = eventDescriptionTextView.text else { return }
            guard let trueDate = selectedDate else { return }
                    
                    
            let storageRef = Storage.storage().reference()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let imageRef = storageRef.child(trueImage)
            let uploadTask = imageRef.putData(trueJPEG, metadata: metadata) { metadata, error in
                guard let metadata = metadata else {
                    return
                }
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else { return }
                   
                    print("successfully uploaded Image")
                    
                    
                    let event = SOCEvent(name: trueName, description: trueDescription, photoURL: downloadURL.relativeString, startTimeStamp: Timestamp(date: trueDate), creator: uid, rsvpUsers: [])
                    
                    FIRDatabaseRequest.shared.setEvent(event) {
                        print("Event created successfully")
                        self.navigationController?.popViewController(animated: true)

                    }
                }
                
            }}
            
    }
    
    @objc func uploadPressed (){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            globalJPEG = jpegData
            globalImage = imageName
            self.photoButton.setTitle("Uploaded", for: .normal)
            self.photoButton.isUserInteractionEnabled = false
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//            let imageRef = storageRef.child(imageName)
//            let uploadTask = imageRef.putData(jpegData, metadata: metadata) { metadata, error in
//                guard let metadata = metadata else {
//                    return
//                }
//                imageRef.downloadURL { url, error in
//                    guard let downloadURL = url else { return }
//                    self.finalImage = downloadURL.relativeString
//                    print("successfully uploaded")
//                    self.photoButton.setTitle("Uploaded", for: .normal)
//                    self.photoButton.isUserInteractionEnabled = false
//                }
//
//            }
            
        }
        
        
        
        picker.dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}

