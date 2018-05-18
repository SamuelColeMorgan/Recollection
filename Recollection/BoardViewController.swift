//
//  BoardViewController.swift
//  Recollection
//
//  Created by Samuel Cole Morgan on 4/30/18.
//  Copyright © 2018 Samuel Cole Morgan. All rights reserved.
//


import UIKit
import Foundation


class BoardViewController: UIViewController,
                           UICollectionViewDataSource,
                           UICollectionViewDelegate,
                           UICollectionViewDelegateFlowLayout {
    
    
    // view controller variables
    
    var win = false
    var recievedGameMode = ""
    var recievedDifficulty = ""
    var turn: String? = nil
    var pickOne = ""
    var pickTwo = ""
    var buttonOne: UIButton? = nil
    var buttonTwo: UIButton? = nil
    
    var progressTimer = Timer()
    var numericTimer = Timer()
    var barProgressTime = 0.0
    var labelProgressTime = 0.0
    var allottedTime = 0.0
    let barTimeInc = 0.001
    let labelTimeInc = 1.0
    var playerOneScore = 0
    var playerTwoScore = 0
    var boardPieces = 0
    var matches = 0
    var bonusTime = 0.0
    
    @IBOutlet weak var difficultyButton: UIButton!
    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var timeProgress: UIProgressView!
    @IBOutlet weak var timeProgressHeight: NSLayoutConstraint!
    @IBOutlet weak var playerOneEmblem: UIImageView!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoEmblem: UIImageView!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let playerOneColor = UIColor(red:0.50, green:0.28, blue:0.87, alpha:1.0)
    let playerTwoColor = UIColor(red:0.94, green:0.68, blue:0.16, alpha:1.0)
    let progressColorOne = UIColor(red:0.50, green:0.28, blue:0.87, alpha:1.0)
    let progressColorTwo = UIColor(red:0.98, green:0.68, blue:0.09, alpha:1.0)
    let progressColorThree = UIColor(red:0.99, green:0.20, blue:0.50, alpha:1.0)
    let defaultCardColor = UIColor(red:0.84, green:0.84, blue:0.85, alpha:1.0)
    
    let defaultButtonImage = UIImage(named: "recollection-symbol.png")
    
    let gridMargin = CGFloat(5)
    var cellWidth = CGFloat(0)
    var cellHeight = CGFloat(0)
    
    let gameBoardArray = [
        "board-piece-1","board-piece-2","board-piece-3",
        "board-piece-4","board-piece-5","board-piece-6",
        "board-piece-7","board-piece-8","board-piece-9",
        "board-piece-10","board-piece-11","board-piece-12"
    ]
    
    let cardColorArray = [
        UIColor(red:0.50, green:0.28, blue:0.87, alpha:1.0),
        UIColor(red:0.94, green:0.68, blue:0.16, alpha:1.0),
        UIColor(red:0.21, green:0.69, blue:0.60, alpha:1.0),
        UIColor(red:0.99, green:0.20, blue:0.50, alpha:1.0),
        UIColor(red:0.35, green:0.59, blue:1.00, alpha:1.0),
        UIColor(red:0.56, green:0.36, blue:0.22, alpha:1.0),
        UIColor(red:0.76, green:0.44, blue:0.80, alpha:1.0),
        UIColor(red:0.73, green:0.75, blue:0.13, alpha:1.0),
        UIColor(red:1.00, green:0.64, blue:0.83, alpha:1.0),
        UIColor(red:1.00, green:0.53, blue:0.14, alpha:1.0),
        UIColor(red:0.10, green:0.62, blue:0.85, alpha:1.0),
        UIColor(red:0.05, green:0.21, blue:0.37, alpha:1.0)
    ]
    
    var shuffledArray = [String]()
    var normalAndEasyArray = [String]()
    
    
    //---------------------------------------------------------------------------
    
    
    // setup game on view load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultyButton.setTitle(recievedDifficulty, for: .normal)
        timeProgress.transform = timeProgress.transform.scaledBy(x: 1, y: 5)
        timeProgress.progress = 1
        randomizeBoard()
        startTimers()
        setGridMargins()
        setupScoreBoard()
    }
    
    //---------------------------------------------------------------------------
    
    
    // setup score board based on game type
    
    func setupScoreBoard() {
        playerOneEmblem.layer.cornerRadius = playerOneEmblem.frame.size.width/2
        playerTwoEmblem.layer.cornerRadius = playerTwoEmblem.frame.size.width/2
        playerOneEmblem.clipsToBounds = true
        playerTwoEmblem.clipsToBounds = true
        switch recievedGameMode {
            case "1 Player":
                playerTwoEmblem.isHidden = true
                playerTwoScoreLabel.isHidden = true
                playerOneEmblem.layer.borderColor = playerOneColor.cgColor
                playerOneEmblem.layer.backgroundColor = playerOneColor.cgColor
                playerOneEmblem.image = UIImage(named: "player-icon-1_current.png")
                playerOneEmblem.layer.borderWidth = 1
            case "2 Player":
                updateTurn(to: "Player 1")
            default:
                break
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // Make easy and normal difficiulty arrays
    
    func makeNormalAndEasyArrays() {
        normalAndEasyArray = [String]()
        var arrayCopy = [String]()
        let arrayLength = (
            recievedDifficulty == "Easy"
            ? 4 : 6
        )
        while normalAndEasyArray.count < arrayLength {
            var index = arc4random_uniform(
                UInt32(arrayLength)
            )
            var newPiece = gameBoardArray[Int(index)]
            while normalAndEasyArray.contains(newPiece) {
                index = arc4random_uniform(
                    UInt32(arrayLength)
                )
                newPiece = shuffledArray[Int(index)]
            }
            normalAndEasyArray.append(newPiece)
        }
        arrayCopy = normalAndEasyArray
        arrayCopy.shuffle()
        normalAndEasyArray.append(contentsOf: arrayCopy)
    }
    
    //---------------------------------------------------------------------------
    
    
    // randomize board array and make 2 copies of each image
    
    func randomizeBoard() {
        var boardArrayCopy = gameBoardArray
        var randomizedArray = [String]()
        var randomNum: Int
        for _ in gameBoardArray {
            randomNum = (
                Int(arc4random_uniform(
                    UInt32(boardArrayCopy.count)
            )))
            randomizedArray.append(boardArrayCopy[randomNum])
            boardArrayCopy.remove(at: randomNum)
        }
        shuffledArray = randomizedArray
        randomizedArray.shuffle()
        shuffledArray.append(contentsOf: randomizedArray)
        switch recievedDifficulty {
            case "Easy":
                makeNormalAndEasyArrays()
            case "Normal":
                makeNormalAndEasyArrays()
            default:
                break
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // Switch player turn (2 player only)
    
    func updateTurn(to: String) {
        if to == "Player 1" {
            turn = "Player 1"
            playerOneEmblem.image = UIImage(named: "player-icon-1_current.png")
            playerTwoEmblem.image = UIImage(named: "player-icon-2.png")
            playerOneEmblem.layer.borderColor = playerOneColor.cgColor
            playerOneEmblem.layer.backgroundColor = playerOneColor.cgColor
            playerTwoEmblem.layer.backgroundColor = nil
            playerOneEmblem.layer.borderWidth = 1
            playerTwoEmblem.layer.borderWidth = 0
        } else {
            turn = "Player 2"
            playerTwoEmblem.image = UIImage(named: "player-icon-2_current.png")
            playerOneEmblem.image = UIImage(named: "player-icon-1.png")
            playerTwoEmblem.layer.borderColor = playerTwoColor.cgColor
            playerTwoEmblem.layer.backgroundColor = playerTwoColor.cgColor
            playerOneEmblem.layer.backgroundColor = nil
            playerTwoEmblem.layer.borderWidth = 1
            playerOneEmblem.layer.borderWidth = 0
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // set cells for collection view
    
    func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
        var returnVal = 0
        switch recievedDifficulty {
            case "Easy":
                returnVal = 8
            case "Normal":
                returnVal = 12
            case "Hard":
                returnVal = 24
            default:
                break
        }
        boardPieces = returnVal
        return returnVal
    }
    
    //---------------------------------------------------------------------------
    
    
    // assign colors to cards on board
    
    func assignCardColor(_ image: String,_ button: UIButton) {
        for (i, _) in gameBoardArray.enumerated() {
            if image == gameBoardArray[i] {
                button.backgroundColor = cardColorArray[i]
            }
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // reset 1st & 2nd pick
    
    func resetPicks() {
        pickOne = ""
        pickTwo = ""
        buttonOne = nil
        buttonTwo = nil
    }
    
    //---------------------------------------------------------------------------
    
    
    // reset score
    
    func resetScore() {
        playerOneScore = 0
        playerTwoScore = 0
        matches = 0
        playerOneScoreLabel.text = ":\(playerOneScore)"
        playerTwoScoreLabel.text = ":\(playerTwoScore)"
    }
    
    //---------------------------------------------------------------------------
    
    
    // reset timers
    
    func resetTimers(_ time: Double) {
        timeProgress.progress = 1
        barProgressTime = time
        labelProgressTime = time
        startTimers()
    }
    
    //---------------------------------------------------------------------------

    
    // reset game
    
    func resetGame() {
        win = false
        var resetVal = 0.0
        boardCollectionView.visibleCells.forEach({ cell in
            guard let boardCell = cell as? BoardCell else {
                fatalError("cell is not of type BoardCell")
            }
            boardCell.boardButton.setImage(defaultButtonImage, for: .normal)
            boardCell.boardButton.isEnabled = true
            boardCell.boardButton.backgroundColor = defaultCardColor
        }); switch recievedDifficulty {
                case "Easy":
                    resetVal = 10.0
                case "Normal":
                    resetVal = 15.0
                case "Hard":
                    resetVal = 45.0
                default:
                    break
        }
        randomizeBoard()
        resetPicks()
        resetScore()
        resetTimers(resetVal)
    }
    
    //---------------------------------------------------------------------------
    
    
    // check for card match
    
    func checkForMatch() {
        if pickOne == pickTwo {
            buttonOne?.isEnabled = false
            buttonTwo?.isEnabled = false
            resetPicks()
            if recievedGameMode == "1 Player" {
                playerOneScore += 1
                matches += 1
                playerOneScoreLabel.text = ":\(playerOneScore)"
            } else {
                switch turn {
                    case "Player 1":
                        playerOneScore += 1
                        playerOneScoreLabel.text = ":\(playerOneScore)"
                        matches += 1
                    case "Player 2":
                        playerTwoScore += 1
                        playerTwoScoreLabel.text = ":\(playerTwoScore)"
                        matches += 1
                    default:
                        break
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.buttonOne?.setImage(self.defaultButtonImage, for: .normal)
                self.buttonTwo?.setImage(self.defaultButtonImage, for: .normal)
                self.buttonOne?.backgroundColor = self.defaultCardColor
                self.buttonTwo?.backgroundColor = self.defaultCardColor
                self.resetPicks()
                switch self.turn {
                    case "Player 1":
                        self.updateTurn(to: "Player 2")
                    case "Player 2":
                        self.updateTurn(to: "Player 1")
                    default:
                        break
                }
            }
        }
        let wonOnEasy = recievedDifficulty == "Easy" && matches >= 4
        let wonOnNormal = recievedDifficulty == "Normal" && matches >= 6
        let wonOnHard = recievedDifficulty == "Hard" && matches >= 12
        if (wonOnEasy || wonOnNormal || wonOnHard) {
            win = true
            GameOver()
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // board button tap handler
    
    @objc func boardButtonTapped(_ sender: UIButton) {
        var gamePiece = shuffledArray[sender.tag]
        if recievedDifficulty == "Easy" || recievedDifficulty == "Normal" {
            gamePiece = normalAndEasyArray[sender.tag]
        }
        let image = UIImage(named: "\(gamePiece).png")
        if pickOne == "" {
            pickOne = gamePiece
            buttonOne = sender
            assignCardColor(pickOne,sender)
            sender.setImage(image, for: .normal)
        } else if sender != buttonOne && pickTwo == "" {
            pickTwo = gamePiece
            buttonTwo = sender
            assignCardColor(pickTwo,sender)
            sender.setImage(image, for: .normal)
            checkForMatch()
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // render collection view cells
    
    func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "boardCell",
            for: indexPath
        ) as! BoardCell
        cell.boardButton.imageView?.contentMode = .scaleAspectFit
        cell.boardButton.tag = indexPath.row
        cell.boardButton.setImage(defaultButtonImage, for: .normal)
        cell.boardButton.addTarget(
            self,
            action: #selector(boardButtonTapped(_:)),
            for: .touchUpInside
        )
        return cell
    }
    
    //---------------------------------------------------------------------------
    
    
    // start game timer
    
    func startTimers() {
        if recievedGameMode == "1 Player" {
            progressTimer = Timer.scheduledTimer(
                timeInterval: barTimeInc,
                target: self,
                selector: #selector(BoardViewController.updateProgressBar),
                userInfo: nil,
                repeats: true
            ); numericTimer = Timer.scheduledTimer(
                timeInterval: labelTimeInc,
                target: self,
                selector: #selector(BoardViewController.updateTimeLabel),
                userInfo: nil,
                repeats: true
            )
            numericTimer.fire()
            progressTimer.fire()
            
        } else {
            timeProgress.isHidden = true
            timeLabel.isHidden = true
            timeProgressHeight.constant = 20
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // Update time progress bar
    
    @objc func updateProgressBar() {
        if barProgressTime >= 0.0 {
            barProgressTime -= barTimeInc
            let progress = Float(barProgressTime) / Float(allottedTime)
            timeProgress.setProgress(progress, animated: true)
            if progress < 0.33 {
                timeProgress.progressTintColor = progressColorThree
            } else if progress < 0.66 {
                timeProgress.progressTintColor = progressColorTwo
            } else {
                timeProgress.progressTintColor = progressColorOne
            }
        } else {
            progressTimer.invalidate()
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // Update numeric time label
    
    @objc func updateTimeLabel() {
        let minutes = (Int(labelProgressTime) / 60) % 60
        let seconds = Int(labelProgressTime) % 60
        let formattedTime = (
            seconds >= 10 ?
            "\(minutes):\(seconds)" :
            "\(minutes):0\(seconds)"
        )
        if labelProgressTime >= 0.0 {
            labelProgressTime -= labelTimeInc
            timeLabel.text = formattedTime
        } else {
            GameOver()
        }
    }
    
    //---------------------------------------------------------------------------
    
    
    // set collection view cell margins
    
    func setGridMargins() {
        let layout = boardCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = gridMargin
        layout.minimumLineSpacing = gridMargin
    }
    
    //---------------------------------------------------------------------------
    
    
    // determine collection view cell dimensions
    
    func collectionView(_
            collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let collectionViewWidth = boardCollectionView.frame.size.width
        let collectionViewheight = boardCollectionView.frame.size.height
        switch recievedDifficulty {
            case "Easy":
                cellWidth = collectionViewWidth/2 - gridMargin
                cellHeight = collectionViewheight/4  - gridMargin
            case "Normal":
                cellWidth = collectionViewWidth/3  - gridMargin
                cellHeight = collectionViewheight/4  - gridMargin
            case "Hard":
                cellWidth = collectionViewWidth/4  - gridMargin
                cellHeight = collectionViewheight/6  - gridMargin
            default:
                break
        }
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    //---------------------------------------------------------------------------
    
    
    // go back to home screen
    
    @IBAction func backToHome(_ sender: UIButton) {
        progressTimer.invalidate()
        numericTimer.invalidate()
        let title = sender.title(for: .normal)!
        var alertTitle = ""
        var alertMessage = ""
        switch title {
            case "Quit":
                alertTitle = "Quit"
                alertMessage = "This will end the current game."
            default:
                alertTitle = "Change Difficulty"
                alertMessage = "You will need to restart the game."
        }
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.default,
            handler: { (action) in
                alert.dismiss(
                    animated: true,
                    completion: nil
                )
                self.startTimers()
        }))
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.destructive,
            handler: { action in
                if let controller = self.navigationController {
                    controller.popViewController(animated: true)
                }
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    
    
    // game over alert
    
    func GameOver() {
        progressTimer.invalidate()
        numericTimer.invalidate()
        var titleMessage = ""
        var alertMessage = "Purple Player: \(playerOneScore). Yellow Player: \(playerTwoScore)"
        if recievedGameMode == "2 Player" {
            if playerOneScore > playerTwoScore {
                titleMessage = "Purple Player Wins!"
            } else if playerOneScore < playerTwoScore {
                titleMessage = "Yellow Player Wins!"
            } else {
                titleMessage = "Draw!"
            }
        } else {
            let possibleMatches = boardPieces/2
            alertMessage = "Matches Found: \(matches) out of \(possibleMatches)"
            if win {
                titleMessage = "You Win!"
            } else {
                titleMessage = "You Lose!"
            }
        }
        let alert = UIAlertController(
            title: titleMessage,
            message: alertMessage,
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(
            title: "Play Again",
            style: UIAlertActionStyle.default,
            handler: { action in
                self.resetGame()
            }))
        alert.addAction(UIAlertAction(
            title: "Quit",
            style: UIAlertActionStyle.default,
            handler: { action in
                if let controller = self.navigationController {
                    controller.popViewController(animated: true)
                }
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    
    
}


// extra shuffle extension

extension Array {
    mutating func shuffle() {
        for _ in 0...count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
