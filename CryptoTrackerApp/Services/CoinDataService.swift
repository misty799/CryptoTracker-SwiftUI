//
//  CoinDataService.swift
//  CryptoTrackerApp
//
//  Created by apple on 22/11/22.
//

import Foundation
import Combine
class CoinDataService{
    @Published var allCoins:[CoinModel]=[]
    var cancellable:AnyCancellable?
    init(){
        getCoins()
        
    }
     func getCoins(){
        print("getting coins")
        guard let url=URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else {return}
        cancellable=NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: NetworkingManager.handleCompletion,receiveValue:{[weak self] (coins) in
                print(coins)
                self?.allCoins=coins
                self?.cancellable?.cancel()
            })
            
        
    }
    
}
