//
//  HomeViewModel.swift
//  CryptoTrackerApp
//
//  Created by apple on 22/11/22.
//

import Foundation
import Combine
class HomeViewModel:ObservableObject{
    @Published var isLoading:Bool=false
    @Published var statistics:[StatisticModel]=[
]
    @Published var allCoins:[CoinModel]=[]
    @Published var portfolioCoins:[CoinModel]=[]
    @Published var searchText:String=""
    @Published var sortOptions:SortOptions = .holdings
    private let coinDataService=CoinDataService()
    private let marketDataService=MarketDataService()
    private let portfolioDataService=PortfolioDataService()
    private var cancellable=Set<AnyCancellable>()
    enum SortOptions{
        case rank,rankReversed,holdings,holdingsReversed,price,priceReversed
    }
    init(){
        addSubscribers()
    }
    func addSubscribers(){
       
        $searchText
            .combineLatest(coinDataService.$allCoins,$sortOptions)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink{[weak self]
                (returnedCoins) in
                self?.allCoins=returnedCoins
            }
            .store(in: &cancellable)
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(mapAllCoinsToPortfoliocoins)
            .sink{[weak self]
                (returnedCoins) in
                guard let self=self else {return }
                self.portfolioCoins=self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellable)

        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            
            .sink{[weak self]
                (value) in
                self?.statistics=value
                self?.isLoading=false
            }
            .store(in: &cancellable)

        
        
            
    }
    func updatePortfolio(coin:CoinModel,amount:Double){
        portfolioDataService.updataPortfolio(coin: coin, amount: amount)
    }
    private func filterAndSortCoins(text:String,coins:[CoinModel],sort:SortOptions)->[CoinModel]{
        var filterCoins=filterCoins(text: text, coins: coins)
    sortCoins(sort: sort, coins: &filterCoins)
        return filterCoins
        
    }
    private func sortCoins(sort:SortOptions,coins:inout [CoinModel]){
        switch sort{
        case .rank,.holdings:
            return coins.sort{$0.rank<$1.rank}
        case .rankReversed,.holdingsReversed:
            return coins.sort{$0.rank>$1.rank}
        case .price:
            return coins.sort{$0.currentPrice<$1.currentPrice}

        case .priceReversed:
            return coins.sort{$0.currentPrice>$1.currentPrice}


            
            
        }
    }
    private func sortPortfolioCoinsIfNeeded(coins:[CoinModel])->[CoinModel]{
        switch sortOptions{
        case .holdings:
            return coins.sorted{$0.currentHoldingsValue>$1.currentHoldingsValue}
        case .holdingsReversed:
            return coins.sorted{$0.currentHoldingsValue<$1.currentHoldingsValue}
        default:
            return coins

        }
    }
    private func filterCoins(text:String,coins:[CoinModel])->[CoinModel]{
        guard !text.isEmpty else {
            
            return coins
        }
        let lowerCaseText=text.lowercased()
        let filterCoins=coins.filter{
            (coin)->Bool in
            return coin.name.lowercased().contains(lowerCaseText) ||
            coin.symbol.lowercased().contains(lowerCaseText) ||
            coin.id
                .lowercased().contains(lowerCaseText)
        }
        return filterCoins

        
        
    }
    private func mapAllCoinsToPortfoliocoins(coinModels:[CoinModel],portfolioEntity:[PortfolioEntity])->[CoinModel]{
        coinModels.compactMap{(coin)->CoinModel? in
                              guard let entity=portfolioEntity.first(where: {$0.coinID==coin.id})
                              else {return nil}
            return coin.updateHoldings(amount:entity.amount )}

        
    }
    private func mapGlobalMarketData(marketDataModel:MarketDataModel?,portfolioCoins:[CoinModel])->[StatisticModel]{
        var state:[StatisticModel]=[]
        guard let data=marketDataModel else {
            return state
        }
        let marketCap=StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange:data.marketCapChangePercentage24HUsd)
        let volume=StatisticModel(title: "24h Volumne", value:data.volume ?? "")
        let btcDominance=StatisticModel(title: "BTC Dominance", value:data.btcDominance ?? "")
    let portfolioValue=portfolioCoins.map{(coin)->Double in
            return coin.currentHoldingsValue
        }.reduce(0,+)
        let previousValue=portfolioCoins.map{(coin)->Double in
            let currentValue=coin.currentHoldingsValue
            let percentageChange=(coin.priceChangePercentage24H ?? 0)/100
            let previousValue=currentValue/(1+percentageChange
            )
            return previousValue
            
        }
            .reduce(0,+)
        let percentageChange=((portfolioValue-previousValue)/previousValue)
        let portfolio=StatisticModel(title: "Portfolio Value", value:portfolioValue.asCurrencyWith2Decimals(),percentageChange: percentageChange)
        
        state.append(contentsOf: [marketCap,volume,btcDominance,portfolio])
        return state

        
    }
    func reloadData(){
        isLoading=true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
        
    }
    
    
}
