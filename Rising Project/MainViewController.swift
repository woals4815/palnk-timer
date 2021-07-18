//
//  ViewController.swift
//  Rising Project
//
//  Created by 정재민 on 2021/07/16.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    
    var currentTotalTime: Int = 0
    var timer = Timer()
    var isTimerOn = false
    var timeWhenGoBackground: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pauseBtn.layer.masksToBounds = true
        pauseBtn.layer.cornerRadius = 5
        
        startBtn.layer.masksToBounds = true
        startBtn.layer.cornerRadius = 5
        
        resetBtn.layer.masksToBounds = true
        resetBtn.layer.cornerRadius = 5
        
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 5
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @IBAction func tabStartBtn(_ sender: UIButton) {
        timer.invalidate()
        isTimerOn = true
        timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(paintTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func tabPauseBtn(_ sender: UIButton) {
        timer.invalidate()
        isTimerOn = false
    }
    
    @IBAction func tabResetBtn(_ sender: UIButton) {
        timer.invalidate()
        isTimerOn = false
        currentTotalTime = 0
        lblTime.text = "00:00:00"
    }
    @objc func paintTime() {
        currentTotalTime += 1
        var minutes: String?
        var seconds: String?
        var milSeconds: String?
        if currentTotalTime / 3600 < 10 {
            minutes = "0\(currentTotalTime / 3600)"
        } else {
            minutes = "\(currentTotalTime / 3600)"
        }
        if (currentTotalTime / 60) < 10 {
            seconds = "0\(currentTotalTime/60)"
        } else if (currentTotalTime/60) > 59{
            let rest = currentTotalTime/60
            seconds = (rest % 60) < 10 ? "0\(rest%60)": "\(rest%60)"
        } else {
            seconds = "\(currentTotalTime/60)"
        }
        if (currentTotalTime % 60) < 10 {
            milSeconds = "0\(currentTotalTime%60)"
        } else {
            milSeconds = "\(currentTotalTime%60)"
        }
        lblTime.text = "\(minutes!):\(seconds!):\(milSeconds!)"
    }
    @objc func appMovedToBackground() {
        print("App moved to background!")
        if isTimerOn {
            timeWhenGoBackground = Date()
            print("Save")
        }
    }
    
    @IBAction func tabSaveBtn(_ sender: UIButton) {
        if let tabBarController = self.parent! as? UITabBarController {
            let myInfoVC = tabBarController.viewControllers![1] as? MyInfoViewController
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateFormatted = dateFormatter.string(from: currentDate)
            let recordTime = lblTime!.text!
            let content = "\(dateFormatted), \(recordTime)"
            myInfoVC?.tableArray.insert(content, at: 0)
            tabBarController.selectedIndex = 1
        }
    }
    @objc func appMovedToForeground() {
        print("App moved to foreground")
        if let backTime = timeWhenGoBackground {
            let elapsed = Date().timeIntervalSince(backTime)
            let duration = (Int(elapsed) * 60)
            currentTotalTime += duration
            timeWhenGoBackground = nil
            print("DURATION: \(duration)")
        }
    }
}

