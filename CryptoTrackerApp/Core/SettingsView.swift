//
//  SettingsView.swift
//  CryptoTrackerApp
//
//  Created by apple on 29/11/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentaion

    var body: some View {
        NavigationView{
            List{
                headerSection
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        print("button pressed")
                        presentaion.wrappedValue.dismiss()
            }, label:{
            Image(systemName: "xmark")
            .font(.headline)
            })
                }
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
extension SettingsView{
    private var headerSection:some View{
        Section(header:Text("Swiftful Thinking")){
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by me.It uses MVVM Architecture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            
        }
    }
}
