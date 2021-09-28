//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    let questionProvider = QuestionProvider()
    var currentQuestion: QuestionProvider.Question?
    var timeElapsed = 0
    var correctHistory: [Bool] = []
    var isPause = false
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            button.setTitleColor(.darkGray, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
                        
            return button
        }
    
    }()

    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    let statButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Stats", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: >> Your Code Here <<
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        // MARK: >> Your Code Here <<
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250)
        ])
        buttons[0].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        view.addSubview(buttons[0])
        NSLayoutConstraint.activate([
            buttons[0].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250),
            buttons[0].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
        view.addSubview(buttons[1])
        buttons[1].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            buttons[1].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttons[1].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
        view.addSubview(buttons[2])
        buttons[2].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            buttons[2].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 650),
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250),
            buttons[2].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        view.addSubview(buttons[3])
        buttons[3].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            buttons[3].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 650),
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttons[3].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        view.addSubview(statButton)
        statButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            statButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            statButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            statButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            statButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -700)
        ])
        view.addSubview(pauseButton)
        pauseButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -250),
            pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -700)
        ])
        
        getNextQuestion()
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        
        // MARK: >> Your Code Here <<
        
        
        // MARK: STEP 10: Stats Button
        // See instructions above.
        
        // MARK: >> Your Code Here <<
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // Action Items:
        // - Reinstantiate timer when view appears
        
        // MARK: >> Your Code Here <<
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        self.currentQuestion = questionProvider.nextQuestion()
        let image: UIImage = currentQuestion!.image
        let choices: [String] = currentQuestion!.choices
        imageView.image = image
        for x in 0...3
        {
            buttons[x].setTitle(choices[x], for: .normal)
            buttons[x].setTitleColor(.darkGray, for: .normal)
        }
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - The timer will fire every one second.
    // - You can use `sender.tag` to identify which button is pressed.
    @objc func timerCallback() {
        
        self.timeElapsed += 1
        
        if self.timeElapsed == 5 {
            correctHistory.append(false)
            answerDisplay(selectedAnswer: -1)
        }
        
        
    }
    
    @objc func answerDisplay(selectedAnswer: Int) {
        // show correct answer for 2 seconds
        // go to next question
        let correctIndex = currentQuestion!.choices.firstIndex(of: currentQuestion!.answer)!
        for x in 0...3
        {
            if x == correctIndex {
                buttons[x].setTitleColor(.green, for: .normal)
            } else if x == selectedAnswer && x != correctIndex {
                buttons[x].setTitleColor(.red, for: .normal)
            }
        }
        self.timeElapsed = -2
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getNextQuestion()
        }
        
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        
        // MARK: >> Your Code Here <<
        let correctIndex = currentQuestion!.choices.firstIndex(of: currentQuestion!.answer)!
        if sender.tag == correctIndex {
            correctHistory.append(true)
        } else {
            correctHistory.append(false)
        }
        answerDisplay(selectedAnswer: sender.tag)
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: correctHistory)
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        timer?.invalidate()
        present(vc, animated: true, completion: nil)
    }
    @objc func didTapPause(_ sender: UIButton){
        if isPause{
            pauseButton.setTitle("Pause", for: .normal)
            isPause = false
            correctHistory = []
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        } else{
            pauseButton.setTitle("Resume", for: .normal)
            isPause = true
            timer?.invalidate()
        }
        
    }
}
