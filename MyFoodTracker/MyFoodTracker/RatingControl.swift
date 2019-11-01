//
//  RatingControl.swift
//  MyFoodTracker
//
//  Created by DKS_mac on 2019/10/14.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit

// 通过代码添加控件时可以通过@IBDesignable注解在Interface Builder中实现实时渲染
@IBDesignable class RatingControl: UIStackView {
    
    // 存放按钮的数组
    private var ratingButtons = [UIButton]()
    
    // 记录标记的等级
    // 未加private访问控制则可以从其它类中访问(public)
    var rating = 0 {
        // observer, 每次设置rating变量都更新星标状态
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    // @IBInspectable使得变量在attributes inspector中可见
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        // 用property observer保证设置的值与实际的值同步
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // initialize the view programatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // load the view from the storyboard
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // load button images
        let bundle = Bundle(for: type(of: self))    // 这句的含义和作用？？
        let filledStar = UIImage(named: "FilledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "EmptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "HighlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // 用for循环向视图中添加button
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            // 根据按钮状态的不同设置不同的图片
            button.setImage(emptyStar, for: .normal)    // 一开始的状态都是normal
            button.setImage(filledStar, for: .selected) // 选中
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // button.backgroundColor = UIColor.red
            
            // Add constraints (height, width)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessbility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Bind event handler to button
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack view
            addArrangedSubview(button)
            
            // 将新创建的按钮加入按钮数组中
            ratingButtons.append(button)
            
        }
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        // print("Button pressed 👍")
        
        guard let index = ratingButtons.firstIndex(of: button)
        else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // 重置
            rating = 0
        }else {
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        // 数组枚举，同时获取下表和元素
        
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) starts set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString         // 可以将String直接赋值给String?类型
            
        }
        
        
        // 也可以这样写
        /*
        for i in 0..<ratingButtons.count {
            ratingButtons[i].isSelected = i < rating
        }
        */
        
    }
    
}
