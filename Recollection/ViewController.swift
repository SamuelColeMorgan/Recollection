//
//  ViewController.swift
//  Recollection
//
//  Created by Samuel Cole Morgan on 4/16/18.
//  Copyright © 2018 Samuel Cole Morgan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // view controller variables

    let customBlue = UIColor(red:0.35, green:0.59, blue:1.00, alpha:1.0)
    let customDarkBlue = UIColor(red:0.04, green:0.04, blue:0.19, alpha:1.0)
    let customGray = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)
    
    var gameMode = "1 Player"
    var difficulty = "Normal"
    
    @IBOutlet weak var onePlayer: UIButton!
    @IBOutlet weak var twoPlayer: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    //---------------------------------------------------------------------------
    
    
    // overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackground()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //---------------------------------------------------------------------------
    
    
    // segue functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let boardController = segue.destination as! BoardViewController
        boardController.recievedDifficulty = difficulty
        boardController.recievedGameMode = gameMode
        var returnVal = 0.0
        switch difficulty {
            case "Easy":
                returnVal = 10.0
            case "Normal":
                returnVal = 15.0
            case "Hard":
                returnVal = 45.0
            default:
                break
        }
        boardController.allottedTime = returnVal
        boardController.labelProgressTime = returnVal
        boardController.barProgressTime = returnVal
    }
    
    //---------------------------------------------------------------------------
    
    
    // my functions
    
    func setStatusBarBackground() {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = customBlue
        view.addSubview(statusBarView)
    }
    
    @IBAction func setGameMode(_ sender: UIButton) {
        let title = sender.title(for: .normal)!
        sender.setTitleColor(customBlue, for: .normal)
        switch title {
            case "1 Player":
                gameMode = "1 Player"
                twoPlayer.setTitleColor(customGray, for: .normal)
            case "2 Player":
                gameMode = "2 Player"
                onePlayer.setTitleColor(customGray, for: .normal)
            default:
            break
        }
    }

    @IBAction func setGameDifficulty(_ sender: UIButton) {
        let title = sender.title(for: .normal)!
        sender.setTitleColor(customBlue, for: .normal)
        switch title {
            case "Easy":
                normalButton.setTitleColor(customGray, for: .normal)
                hardButton.setTitleColor(customGray, for: .normal)
                difficulty = "Easy"
            case "Normal":
                easyButton.setTitleColor(customGray, for: .normal)
                hardButton.setTitleColor(customGray, for: .normal)
                difficulty = "Normal"
            case "Hard":
                normalButton.setTitleColor(customGray, for: .normal)
                easyButton.setTitleColor(customGray, for: .normal)
                difficulty = "Hard"
            default:
                break
        }
        
    }
    
    @IBAction func startGame(_ sender: RoundedButton) {
        performSegue(withIdentifier: "goToBoard", sender: self)
    }
    
    //---------------------------------------------------------------------------
    
    
}

