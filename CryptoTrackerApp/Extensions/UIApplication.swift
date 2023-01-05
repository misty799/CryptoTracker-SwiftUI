//
//  UIApplication.swift
//  CryptoTrackerApp
//
//  Created by apple on 23/11/22.
//

import Foundation
import SwiftUI
extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
