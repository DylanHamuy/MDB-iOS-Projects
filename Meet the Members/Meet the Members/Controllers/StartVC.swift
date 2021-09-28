//
//  StartVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit


class StartVC: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .darkGray
        
        label.text = "Meet the Member"
        
        // == NSTextAlignment(expected type).center
        label.textAlignment = .center
        
        // == UIFont.systemFont(ofSize: 27, UIFont.weight.medium)
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        // Must have if you are using constraints.
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Start", for: .normal)
        
        button.setTitleColor(.darkGray, for: .normal)
        
        button.backgroundColor = .white
        
        button.titleLabel?.font = .systemFont(ofSize: 27)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(welcomeLabel)
        

        NSLayoutConstraint.activate([

            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            // For your understanding, here's what it's saying:
            //     welcomeLabel.leadingAnchor = view.leadingAnchor + 50
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            //     welcomeLabel.trailingAnchor = view.trailingAnchor - 50
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(startButton)

        NSLayoutConstraint.activate([

            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),

            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
        
        startButton.addTarget(self, action: #selector(didTapStart(_:)), for: .touchUpInside)
    }
    
    @objc func didTapStart(_ sender: UIButton) {
        let vc = MainVC()
        present(vc, animated: true, completion: nil)
    }
}

