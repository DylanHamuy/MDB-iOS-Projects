//
//  FeedVC.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/17/21.
//

import UIKit
import SwiftUI

class FeedVC: UIViewController {
    
    var tableView : UITableView!
    var selectedEvent : SOCEvent!
    var allEvents : [SOCEvent]! = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabaseRequest.shared.linkEvents()
        //Notification Center
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveUpdate),
            name: Notification.Name("eventsUpdated"), object: nil)
    
        //Sign out button
        let backButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapSignOut(_:)))
        backButton.tintColor = .blue
        self.navigationItem.leftBarButtonItem = backButton

        
        tableView = UITableView(frame: CGRect(x: 10, y: 88, width: view.frame.width-20, height: view.frame.height-88))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedVCCell.self, forCellReuseIdentifier: "eventCell")
        view.addSubview(tableView)
        

    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        SOCAuthManager.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
    @objc func didReceiveUpdate(){
        let updatedEvents = FIRDatabaseRequest.shared.allEvents
        allEvents = updatedEvents
    }
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! FeedVCCell
        let size = CGSize(width: tableView.frame.width, height: height(for: indexPath))
        cell.initCellFrom(size: size)
        cell.selectionStyle = .none
        cell.event = allEvents?[indexPath.row]
        return cell
    }
    
    func height(for index: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(for: indexPath)
    }
    
}
