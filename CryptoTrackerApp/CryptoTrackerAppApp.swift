//
//  CryptoTrackerAppApp.swift
//  CryptoTrackerApp
//
//  Created by apple on 22/11/22.
//

import SwiftUI

@main
struct CryptoTrackerAppApp: App {
    @StateObject private var vm=HomeViewModel()
    @State private var showLaunchView:Bool=true
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes=[.foregroundColor:UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes=[.foregroundColor:UIColor(Color.theme.accent)]
    }
    var body: some Scene {
        WindowGroup {
            ZStack{
                
            
            NavigationView{
            HomeView()
                    .navigationBarHidden(true)
                
            }
            .environmentObject(vm)
                ZStack{
                    if showLaunchView{
                
                LaunchView(showLaunchView: $showLaunchView)
                    .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
