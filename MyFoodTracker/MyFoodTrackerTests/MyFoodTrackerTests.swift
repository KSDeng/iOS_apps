//
//  MyFoodTrackerTests.swift
//  MyFoodTrackerTests
//
//  Created by DKS_mac on 2019/10/14.
//  Copyright © 2019 dks. All rights reserved.
//

import XCTest
@testable import MyFoodTracker

// Swift默认将所有属性、函数的访问控制设置为public，可以从外部访问，除非显式设置为private

class MyFoodTrackerTests: XCTestCase {

    func testMealInitializationSucceeds() {
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 3)
        XCTAssertNotNil(positiveRatingMeal)
        
    }
    
    func testMealInitializationFails() {
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 5)
        XCTAssertNil(emptyStringMeal)
        
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }

}
