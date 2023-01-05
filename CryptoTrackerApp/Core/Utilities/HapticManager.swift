//
//  HapticManager.swift
//  CryptoTrackerApp
//
//  Created by apple on 27/11/22.
//

import Foundation
import UIKit
class HapticManager{
    static private let generator=UINotificationFeedbackGenerator()
    
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
