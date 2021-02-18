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
    
    var player: Character!
    var enemy : Character!
    
    
//    var playerHP: Int = 100
//    var playerMP: Int = 0
//    var enemyHP: Int = 200
//    var enemyMP: Int = 0
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        
        updateUI()
        
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
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
      
      }
    
    @objc func updateGame(){
        
        player.currentMP += 1
        
        if player.currentMP >= 20{
            
            isPlayerAttackAvailable = true
            player.currentMP = 20
            
        }else{
            
            isPlayerAttackAvailable = false
            
        }
        
        enemy.currentMP += 1
        
        if enemy.currentMP >= 35{
            
            enemyAttack()
            enemy.currentMP = 0
            
        }
        
        updateUI()
        
    }
    
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= 20
        updateUI()
        
        judgeBattle()
        
    }
    
    func updateUI(){
        
        playerHPLabel.text = "\(player.currentHP)/\(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP)/\(player.maxMP)"
        
        enemyHPLabel.text = "\(enemy.currentHP)/\(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP)/\(enemy.maxMP)"
        
    }
    
    func judgeBattle(){
        if player.currentHP <= 0{
            
            finishBattle(vanishImageView: playerImageView, isPlayewWin: false)
            
        }else if enemy.currentHP <= 0{
            
            finishBattle(vanishImageView: enemyImageView, isPlayewWin: true)
            
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
            
            enemy.currentHP -= 30
            player.currentMP = 0
            
            updateUI()
            
        }
        
        judgeBattle()
        
    }
    


}

