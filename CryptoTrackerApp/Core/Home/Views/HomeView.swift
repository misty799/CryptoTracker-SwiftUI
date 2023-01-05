//
//  HomeView.swift
//  CryptoTrackerApp
//
//  Created by apple on 22/11/22.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio:Bool=false
    @State private var selectedCoin:CoinModel?=nil
    @State private var showDetailView:Bool=false
    @State private var showPortFolioView:Bool=false
    @State private var showSettingsView:Bool=false
    @EnvironmentObject private var vm:HomeViewModel
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortFolioView,content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            VStack{
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText:$vm.searchText)
                columnTitles
                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))

                }
                if showPortfolio {
                    ZStack(alignment:.top){
                        if vm.portfolioCoins.isEmpty&&vm.searchText.isEmpty{
                            Text("You haven't added any coins to your portfolio yet. Click the + button to get started! ")
                                .font(.callout)
                                .foregroundColor(Color.theme.accent)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(50)
                        }
                        else{
                        
                        
                    
                    portfolioCoinsList
                        }
                    }
                        .transition(.move(edge: .trailing))
                    
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView,content: {
                SettingsView()
            })
        }
        .background(
            NavigationLink(destination:DetailLoadingView(coin: $selectedCoin) , isActive: $showDetailView, label:{EmptyView()}))
    }
}
extension HomeView{
    private var homeHeader:some View{
        HStack{
            CircleButtonView(iconName:!showPortfolio ? "info" :"plus")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio{
                        showPortFolioView.toggle()
                        
                    }
                    else{
                        showSettingsView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180:0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
            
        }
        .padding(.horizontal)

    }
    private var allCoinsList:some View{
        List{
            ForEach(vm.allCoins){
                coin in
                CoinRowView(coin:coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture{
                        segve(coin: coin)
                    }
            

                }

        
    }
        .listStyle(PlainListStyle())

    }
    private func segve(coin:CoinModel){
        selectedCoin=coin
        showDetailView.toggle()
        
    }
    private var portfolioCoinsList:some View{
        List{
            ForEach(vm.portfolioCoins){
                coin in
                CoinRowView(coin:coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))

                }

        
    }
        .listStyle(PlainListStyle())

    }
    private var columnTitles:some View{
        HStack{
            HStack(spacing:4){
                Text("Coin")

                Image(systemName: "chevron.down")
                    .opacity((vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 :180))
                
            }
            .onTapGesture{
                withAnimation(.default){
                vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio{
                HStack(spacing:4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .holdings || vm.sortOptions == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .holdings ? 0 :180))


                    

                    
                }
                .onTapGesture{
                    withAnimation(.default){
                    vm.sortOptions = vm.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
                }

            }
            HStack(spacing:4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOptions == .price || vm.sortOptions == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOptions == .price ? 0 :180))


                

                
            }
            
                .frame(width:UIScreen.main.bounds.width/3.5,alignment:.trailing)
                .onTapGesture{
                    withAnimation(.default){
                    vm.sortOptions = vm.sortOptions == .price ? .priceReversed : .price
                    }
                }

            Button(action: {
                withAnimation(.linear(duration: 2.0)){
                    vm.reloadData()
                    
                }
                
            }, label: {
                Image(systemName: "goforward")
                
            })
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0),anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)

    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}
