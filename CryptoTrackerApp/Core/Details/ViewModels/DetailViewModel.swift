//
//  DetailViewModel.swift
//  CryptoTrackerApp
//
//  Created by apple on 28/11/22.
//

import Foundation
import Combine
class DetailViewModel:ObservableObject{
    @Published var overViewStatistics:[StatisticModel]=[]
    @Published var additionalStatistics:[StatisticModel]=[]
    @Published var coinDescription:String?=nil
    @Published var websiteURL:String?=nil

    @Published var redditURL:String?=nil

    
    private let coinDetailService:CoinDetailDataService
    @Published var coin:CoinModel
    private var cancellable=Set<AnyCancellable>()
    init(coin:CoinModel){
        self.coin=coin
        self.coinDetailService=CoinDetailDataService(coin:coin)
        addSubcribers()
    }
    private func addSubcribers(){
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink{[weak self]
            (returnedCoinDetails) in
            print(returnedCoinDetails)
                self?.overViewStatistics=returnedCoinDetails.overview
                self?.additionalStatistics=returnedCoinDetails.additional
            
        }
        .store(in: &cancellable)
        coinDetailService.$coinDetails.sink{
            [weak self] (returnedCoinDetails) in
            self?.coinDescription=returnedCoinDetails?.readableDescription
            self?.redditURL=returnedCoinDetails?.links?.subredditURL
            self?.websiteURL=returnedCoinDetails?.links?.homepage?.first
        }
        .store(in: &cancellable)
    }
    
    private func mapDataToStatistics(coinDetailsModel:CoinDetailModel?,coinModel:CoinModel)->(overview:[StatisticModel],additional:[StatisticModel]){
        let price=coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange=coinModel.priceChangePercentage24H
        let priceStat=StatisticModel(title:"Current Price", value: price, percentageChange: pricePercentageChange)
        let marketCap="$"+(coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange=coinModel.marketCapChangePercentage24H
        let marketCapStat=StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        let rank="\(coinModel.rank)"
        let rankStat=StatisticModel(title: "Rank", value: rank)
        let volume="$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat=StatisticModel(title: "Volume", value: volume)
        let overViewArray:[StatisticModel]=[priceStat,marketCapStat,rankStat,volumeStat]
        //For additional array
        let high=coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat=StatisticModel(title: "24h High", value: high)
        let low=coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat=StatisticModel(title: "24h Low", value: low)
        let pricChange=coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricepercentChange2=coinModel.priceChangePercentage24H
        let priceChangeStat=StatisticModel(title: "24h Price Change", value: pricChange,percentageChange: pricepercentChange2)
        let marketCapChange2="$"+(coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2=coinModel.marketCapChangePercentage24H
        let marketCapChangeStat=StatisticModel(title: "24h Market Cap Change", value: marketCapChange2, percentageChange: marketCapPercentChange2)
        let blockTime=coinDetailsModel?.blockTimeInMinutes ?? 0
        let blockTimeString=blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat=StatisticModel(title: "Block Time", value: blockTimeString)
        let hashing=coinDetailsModel?.hashingAlgorithm ?? "n/a"
        let hashingStat=StatisticModel(title: "Hashing Algorithm", value: hashing)
        let additionalArray=[highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStat]
        return (overViewArray,additionalArray)

    }
}
