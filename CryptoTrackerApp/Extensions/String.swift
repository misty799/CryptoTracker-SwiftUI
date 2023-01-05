//
//  String.swift
//  CryptoTrackerApp
//
//  Created by apple on 29/11/22.
//

import Foundation
extension String{
    var removingHTMLOccurences:String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression,range: nil)
    }
}
