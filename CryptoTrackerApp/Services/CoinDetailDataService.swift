//
//  CoinDetailDataService.swift
//  CryptoTrackerApp
//
//  Created by apple on 28/11/22.
//

import Foundation

import Combine
class CoinDetailDataService{
    @Published var coinDetails:CoinDetailModel?=nil
    let coin:CoinModel
    var cancellable:AnyCancellable?
    init(coin:CoinModel){
        self.coin=coin
        getCoinsDetails()
        
    }
     func getCoinsDetails(){
        print("getting coins")
         guard let url=URL(string:"https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else {return}
        cancellable=NetworkingManager.download(url: url)
             .decode(type:CoinDetailModel.self, decoder: JSONDecoder())
             .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: NetworkingManager.handleCompletion,receiveValue:{[weak self] (coinDetails) in
            print(coinDetails)
            
                self?.coinDetails=coinDetails
                self?.cancellable?.cancel()
            })
            
        
    }
    
}
