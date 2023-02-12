//
//  GameViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.01.2023.
//

import UIKit

class GameViewController: UIViewController {

    
    
    
    
    
    
    // en yüksek skora databaseye kaydedilecek
    
    
    
    
    
    
    
    
    
    
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var pArray = [UIImageView]()
    var hideTimer =  Timer()
    var highScore = 0
    var bhideTimer = Timer()
    var btimer = Timer()
    
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var p1: UIImageView!
    @IBOutlet var p2: UIImageView!
    @IBOutlet var p3: UIImageView!
    @IBOutlet var p4: UIImageView!
    @IBOutlet var p5: UIImageView!
    @IBOutlet var p6: UIImageView!
    @IBOutlet var p7: UIImageView!
    @IBOutlet var p8: UIImageView!
    @IBOutlet var p9: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //highScore
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore1")
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "HighScore: \(highScore)"
        }
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highScoreLabel.text = "HighScore: \(highScore)"
        }
        
        scoreLabel.text = "Score: \(score)"
        //images
        p1.isUserInteractionEnabled = true
        p2.isUserInteractionEnabled = true
        p3.isUserInteractionEnabled = true
        p4.isUserInteractionEnabled = true
        p5.isUserInteractionEnabled = true
        p6.isUserInteractionEnabled = true
        p7.isUserInteractionEnabled = true
        p8.isUserInteractionEnabled = true
        p9.isUserInteractionEnabled = true
        
        
        
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        p1.addGestureRecognizer(recognizer1)
        p2.addGestureRecognizer(recognizer2)
        p3.addGestureRecognizer(recognizer3)
        p4.addGestureRecognizer(recognizer4)
        p5.addGestureRecognizer(recognizer5)
        p6.addGestureRecognizer(recognizer6)
        p7.addGestureRecognizer(recognizer7)
        p8.addGestureRecognizer(recognizer8)
        p9.addGestureRecognizer(recognizer9)
        
        
        pArray = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p1,p2,p3,p4,p5,p6,p7,p8,p9]
        
        
        
        
        //timers
        counter = 10
        timeLabel.text = String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideKeny), userInfo: nil, repeats: true)
        hideKeny()
        
    }
    
    @IBAction func tryAgainButton(_ sender: UIButton) {
        if counter != 0 {
            hideTimer.invalidate()
            timer.invalidate()
            btimer.invalidate()
            bhideTimer.invalidate()
           
            score = 0
            scoreLabel.text = "Score: \(score)"
            
            counter = 10
            timeLabel.text = String(counter)
            btimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            bhideTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(bhideKeny), userInfo: nil, repeats: true)
            if self.score > self.highScore {
                self.highScore = self.score
                highScoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highScore1")
            }
        }
        
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            btimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            bhideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(bhideKeny), userInfo: nil, repeats: true)

            
            
            score = 0
            scoreLabel.text = "Score: \(score)"
            counter = 10
            timeLabel.text = String(counter)
            for keny in pArray {
                keny.isHidden = true
            }
            let random = arc4random_uniform(UInt32(pArray.count - 1))
            pArray[Int(random)].isHidden = false
            if self.score > self.highScore {
                self.highScore = self.score
                highScoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highScore1")
            }
    }


    }
    @objc func bhideKeny(){
        for keny in pArray {
            keny.isHidden = true
        }
        let random = arc4random_uniform(UInt32(pArray.count - 1))
        pArray[Int(random)].isHidden = false
        if score == 10 {
            score += 1
            scoreLabel.text = "Score: \(score)"
            counter += 4
            timeLabel.text = String(counter)
        }
        if score == 20 {
            counter += 5
            timeLabel.text = String(counter)
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        if score == 30 {
            counter += 5
            timeLabel.text = String(counter)
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    @objc func hideKeny(){
        for keny in pArray {
            keny.isHidden = true
        }
        let random = arc4random_uniform(UInt32(pArray.count - 1))
        pArray[Int(random)].isHidden = false
        if score == 10 {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        if score == 20 {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        if score == 30 {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        if score == 11 {
            counter += 4
            timeLabel.text = String(counter)
        }
        if score == 21 {
            counter += 4
            timeLabel.text = String(counter)
        }
        if score == 31 {
            counter += 4
            timeLabel.text = String(counter)
        }
    }
    
    
    
    
    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    @objc func countdown(){
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            btimer.invalidate()
            bhideTimer.invalidate()
            for keny in pArray {
                keny.isHidden = true
                if self.score > self.highScore {
                    self.highScore = self.score
                    highScoreLabel.text = "Highscore: \(self.highScore)"
                    UserDefaults.standard.set(self.highScore, forKey: "highScore1")
                }
            }
            let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { [self]  UIAlertAction in
                //replay function
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 11
                self.timeLabel.text = String(self.score)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
                hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideKeny), userInfo: nil, repeats: true)
                
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
    }
        
   
    
    
    
    
    }
}
