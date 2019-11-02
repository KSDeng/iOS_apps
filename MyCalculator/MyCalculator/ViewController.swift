//
//  ViewController.swift
//  MyCalculator
//
//  Created by DKS_mac on 2019/10/30.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import AVFoundation

//TODO: 结果显示Label的AutoShrink

// 处理浮点数计算精度问题(用例:5.02 * 5 = 25.1)
extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func fractionCount() -> Int {
        // 处理小数的科学计数法
        if String(self).contains("e"){
            return self.sciToDec().split(separator: ".")[1].count
        }else {
            if Double(Int(self)) ==  self {
                return 0
            } else{
                return String(self).split(separator: ".")[1].count
            }
        }
    }
    
    // 科学计数法转十进制字符串
    func sciToDec() -> String {
        let numberString = String(self)
        if numberString.contains("e"){
            let strings = numberString.split(separator: "e")
            let p1 = strings[0], p2 = strings[1]
            
            let count1 = p1.contains(".") ? p1.split(separator: ".")[1].count : 0
            let count2 = abs((p2 as NSString).integerValue)
            
            return String(format: "%.\(count1 + count2)f", self)
        } else {
            return numberString
        }
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var multiplyButton: UIButton!
    
    @IBOutlet weak var divideButton: UIButton!
    
    
    
    // 操作符按钮的初始背景颜色
    var originalBkgColor = UIColor.orange
    
    // 状态枚举变量(上一次计算)
    enum operation {
        case add, minus, multiply, divide, wait
    }
    
    // 当前状态
    var currentState = operation.wait
    
    // 音效播放器
    var soundPlayer: AVAudioPlayer!
    
    // 按下的按钮(用于改变控件style)
    var buttonPressed = operation.wait {
        willSet {
            switch(newValue){
            case .add:
                addButton.backgroundColor = UIColor.red
                minusButton.backgroundColor = originalBkgColor
                multiplyButton.backgroundColor = originalBkgColor
                divideButton.backgroundColor = originalBkgColor
            case .minus:
                addButton.backgroundColor = originalBkgColor
                minusButton.backgroundColor = UIColor.red
                multiplyButton.backgroundColor = originalBkgColor
                divideButton.backgroundColor = originalBkgColor
            case .multiply:
                addButton.backgroundColor = originalBkgColor
                minusButton.backgroundColor = originalBkgColor
                multiplyButton.backgroundColor = UIColor.red
                divideButton.backgroundColor = originalBkgColor
            case .divide:
                addButton.backgroundColor = originalBkgColor
                minusButton.backgroundColor = originalBkgColor
                multiplyButton.backgroundColor = originalBkgColor
                divideButton.backgroundColor = UIColor.red
            default:
                addButton.backgroundColor = originalBkgColor
                minusButton.backgroundColor = originalBkgColor
                multiplyButton.backgroundColor = originalBkgColor
                divideButton.backgroundColor = originalBkgColor
            }
        }
    }
    
    // 当前是否为新输入的数字
    var ifNewNumber = true
    // 缓存当前数字
    var numberCache = 0.0
    
    // 是否发生错误
    var ifError = false {
        willSet {
            if (newValue){
                labelValueBuffer = "错误"
            } else {
                labelValueBuffer = "0"
            }
        }
    }
    // 是否需要显示小数点
    var ifDot = false
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    // 给标签赋值的缓冲，进行显示之前的处理
    var labelValueBuffer: String = "0" {
        willSet {
            
            if(ifError){
                return
            }
            
            // "0."的特殊情况
            if newValue == "0." {
                resultLabel.text = newValue
                return
            }
            
            // 当前值能转为Double
            if let tmpValue = Double(newValue){
                
                let tmpInt = Int(tmpValue)
                // 小数部分为0，且当前不需要显示小数点
                if Double(tmpInt) == tmpValue && !ifDot {
                    resultLabel.text = String(tmpInt)
                    return
                }
            }
            // 不能转为Double或小数部分不为0
            resultLabel.text = newValue
            
        }
    }
    
    
    @IBAction func clearAction(_ sender: UIButton) {
        playSound()
        
        ifError = false     // 这一句必须放在最前面, 否则会影响labelValueBuffer的赋值
        
        labelValueBuffer = "0"
        currentState = .wait
        ifNewNumber = true
        numberCache = 0.0
        ifDot = false
        buttonPressed = .wait
        
    }
    
    
    @IBAction func toggleAction(_ sender: UIButton) {
        playSound()
        
        if(ifError){
            return
        }
        
        let currentNumber = Double(labelValueBuffer)!
        labelValueBuffer = String(0 - currentNumber)
    }
    
    @IBAction func percentAction(_ sender: UIButton) {
        playSound()
        
        if(ifError){
            return
        }
        
        let currentNumber = Double(labelValueBuffer)!
        labelValueBuffer = String((currentNumber * 0.01).roundTo(places: currentNumber.fractionCount() + 0.01.fractionCount()))
        
    }
    
    @IBAction func operatorAction(_ sender: UIButton) {
        playSound()
        
        if(ifError){
            return
        }
        
        let operationText = sender.titleLabel!.text!
        let currentNumber = Double(labelValueBuffer)!
        
        // 连续两次按下同一个运算符，不做任何事情
        if (operationText == "+" && buttonPressed == .add) ||
            (operationText == "-" && buttonPressed == .minus) ||
            (operationText == "×" && buttonPressed == .multiply) ||
            (operationText == "/" && buttonPressed == .divide) {
            return
        }else{
            
        }
        
        // 除数为0直接报错
        if (currentState == .divide && (currentNumber == 0.0 || Int(currentNumber) == 0)){
            ifError = true
            return
        }
        
        let currentResult: Double
        

        if(buttonPressed == .wait){
            // 根据状态计算结果
            switch currentState {
            case .add:
                currentResult = (numberCache + currentNumber).roundTo(places: numberCache.fractionCount() + currentNumber.fractionCount())
            case .minus:
                currentResult = (numberCache - currentNumber).roundTo(places: numberCache.fractionCount() + currentNumber.fractionCount())
            case .multiply:
                currentResult = (numberCache * currentNumber).roundTo(places: numberCache.fractionCount() + currentNumber.fractionCount())
            case .divide:
                currentResult = numberCache / currentNumber
            case .wait:
                currentResult = currentNumber
            }
        } else {
            currentResult = currentNumber
            renewButtonStatus(operation: operationText)
        }

        
        // 小数部分为0，不显示小数点
        if currentResult == Double(Int(currentResult)) {
            ifDot = false
        }
        
        labelValueBuffer = String(currentResult)        // 更新结果显示
        numberCache = currentResult                     // 更新Cache
        ifNewNumber = true                              // 下一个数字重新输入
        
        
        
        // 根据点击的运算符修改状态
        switch operationText {
        case "+":
            currentState = .add
        case "-":
            currentState = .minus
        case "×":
            currentState = .multiply
        case "/":
            currentState = .divide
        case "=":
            currentState = .wait
            numberCache = 0.0
        default:
            fatalError("Unrecognized operation!")
        }
        renewButtonStatus(operation: operationText)
        
    }
    
    private func renewButtonStatus(operation: String){
        switch(operation){
        case "+":
            buttonPressed = .add
        case "-":
            buttonPressed = .minus
        case "×":
            buttonPressed = .multiply
        case "/":
            buttonPressed = .divide
        case "=":
            buttonPressed = .wait
        default:
            return
        }
    }
    
    @IBAction func numberInputAction(_ sender: UIButton) {
        playSound()
        
        buttonPressed = .wait
        let numberText = sender.titleLabel!.text!
        
        // 修改显示的数字
        if (ifNewNumber){
            labelValueBuffer = numberText
            ifNewNumber = false
        } else {
            labelValueBuffer += numberText
        }
        
    }
    
    
    @IBAction func dotAction(_ sender: UIButton) {
        playSound()
        
        // 新输入数字按小数点默认整数部分为0
        if(ifNewNumber){
            labelValueBuffer = "0."
            ifNewNumber = false
            ifDot = true
        } else{
            if(!labelValueBuffer.contains(".")){
                labelValueBuffer += "."
                ifDot = true
            }
            // 当前已有小数点不做任何事情
        }

    }
    
    // 播放音效
    private func playSound() {
        soundPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        originalBkgColor = addButton.backgroundColor!
        
        // 预加载音效
        let url = Bundle.main.url(forResource: "button", withExtension: "wav")
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url!)
        } catch {
            print(error)
        }
        
    }
    
    // Change the sytle and color of a status bar to use white font.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

