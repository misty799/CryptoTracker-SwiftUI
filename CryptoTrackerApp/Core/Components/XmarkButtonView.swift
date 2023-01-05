//
//  XmarkButtonView.swift
//  CryptoTrackerApp
//
//  Created by apple on 25/11/22.
//

import SwiftUI

struct XmarkButtonView: View {
    @Environment(\.presentationMode) var presentaion

    var body: some View {
        Button(action: {
            print("button pressed")
            presentaion.wrappedValue.dismiss()
}, label:{
Image(systemName: "xmark")
.font(.headline)
})
        
    }
}

struct XmarkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButtonView()
    }
}
