//
//  DetailView.swift
//  CryptoTrackerApp
//
//  Created by apple on 27/11/22.
//

import SwiftUI
struct DetailLoadingView:View{
    @Binding var coin:CoinModel?
    init(coin:Binding<CoinModel?>){
        self._coin=coin
        print("calling init")
    }
    var body: some View {
        ZStack{
            if let coin=coin{
            DetailView(coin: coin)
            }
        }
    }


    
}

struct DetailView: View {
    @StateObject var vm:DetailViewModel
    @State private var showFullDescription:Bool=false
    private let columns:[GridItem]=[
        GridItem(.flexible()),
        GridItem(.flexible())]
    
    init(coin:CoinModel){
    _vm=StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView{
            VStack{                ChartView(coin:vm.coin)

                
            
            VStack(spacing:20){
                   
                overViewTitle
                Divider()
                overviewGrid
                descriptionSection
                
                additionalTitle
                Divider()
                additionalGrid
                websiteSection
                    
                
                
            }
            .padding()
            }
            
        }
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                navigationTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        DetailView(coin:dev.coin)
        }
    }
}
extension DetailView{
    private var navigationTrailingItems:some View{
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }

    }
    private var overViewTitle:some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth:.infinity,alignment: .leading)

    }
    private var additionalTitle:some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth:.infinity,alignment: .leading)

        
    }
    private var overviewGrid:some View{
        LazyVGrid(
        columns: columns,
        alignment: .leading,
        spacing: nil,
        pinnedViews: [],
        content:{
            ForEach(vm.overViewStatistics){
                stat in StatisticView(stat:stat)
            }
        })

    }
    private var additionalGrid:some View{
        LazyVGrid(
        columns: columns,
        alignment: .leading,
        spacing: nil,
        pinnedViews: [],
        content:{
            ForEach(vm.additionalStatistics){
                stat in StatisticView(stat: stat)
            }
        })


        
    }
    private var descriptionSection:some View{
        ZStack{
            if let coinDescription=vm.coinDescription,!coinDescription.isEmpty{
                VStack(alignment:.leading){
                    
                
                Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                    .font(.callout)
                    .foregroundColor(Color.theme.secondaryText)
                    Button(action:{
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                        
                    } ,label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                    })
                        .accentColor(Color.blue)
                }
                .frame(maxWidth:.infinity , alignment: .leading)
            }
        }

    }
    private var websiteSection:some View{
        VStack(alignment:.leading, spacing:10){
            if let websiteString=vm.websiteURL,let url=URL(string: websiteString){
                Link("Website", destination: url)
            }
            if let redditString=vm.redditURL,let url=URL(string: redditString){
                Link("Reddit",destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth:.infinity,alignment:.leading)
        .font(.headline)

    }
}
