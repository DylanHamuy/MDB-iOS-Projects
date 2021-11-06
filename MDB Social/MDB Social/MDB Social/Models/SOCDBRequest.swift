//
//  SOCDBRequest.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    
    private var eventListener : ListenerRegistration?
    
    var allEvents: [SOCEvent] = []{
        didSet{
            NotificationCenter.default.post(name: Notification.Name("eventsUpdated"),
                object: nil)
        }
        
    }
    

    func linkEvents(){
        eventListener = db.collection("events").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            let allEvents = documents.compactMap { document in
                return try? document.data(as: SOCEvent.self)
            }
            self.allEvents = allEvents
        }
    }
    
    
    func setUser(_ user: SOCUser, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: SOCEvent, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    private func unlinkEvents() {
        eventListener?.remove()
    }
    
    /* TODO: Events getter */
    //read through read data up to order and limit data
    //read in info from firebase and put into array format like pokemon

}
