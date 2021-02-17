//
//  ViewController.swift
//  TechMon
//
//  Created by 小西星七 on 2021/02/14.
//

import UIKit

class BattleViewController: UIViewController {

    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var playerHP: Int = 100
    var playerMP: Int = 0
    var enemyHP: Int = 200
    var enemyMP: Int = 0
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP)/100"
        playerMPLabel.text = "\(playerMP)/20"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP)/200"
        enemyMPLabel.text = "\(enemyMP)/35"
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateGame),
            userInfo: nil,
            repeats: true
            )
        
        gameTimer.fire()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_ battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
      
      }
    
    @objc func updateGame(){
        
        playerMP += 1
        if playerMP >= 20{
            
            isPlayerAttackAvailable = true
            playerMP = 20
            
        }else{
            
            isPlayerAttackAvailable = false
            
        }
        
        enemyMP += 1
        if playerMP >= 35{
            
            
            enemyMP = 0
            
        }else{
            
            isPlayerAttackAvailable = false
            
        }
        
        playerMPLabel.text = "\(playerMP)/20"
        enemyMPLabel.text = "\(enemyMP)/35"
        
    }
    
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        playerHPLabel.text = "\(playerHP)/100"
        
        if playerHP <= 0{
            
            //
            
        }
        
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayewWin: Bool) {
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        
        if  isPlayewWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
            
        }else{
            
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
            
        }
        
        let alert: UIAlertController = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func attackAction() {
        
        if isPlayerAttackAvailable{
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemyHP -= 30
            playerMP = 0
            
            playerMPLabel.text = "\(playerMP)/20"
            enemyHPLabel.text = "\(enemyHP)/200"
            
        }
        
        if enemyHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayewWin: true)
        }
        
    }
    


}

