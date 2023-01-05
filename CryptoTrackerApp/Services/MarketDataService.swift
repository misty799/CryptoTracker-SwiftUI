//
//  MarketDataService.swift
//  CryptoTrackerApp
//
//  Created by apple on 24/11/22.
//

import Foundation

import Combine
class MarketDataService{
    @Published var marketData:MarketDataModel?=nil
    var cancellable:AnyCancellable?
    init(){
        getData()
        
    }
    func getData(){
        print("getting global data")
        guard let url=URL(string:"https://api.coingecko.com/api/v3/global"
)
        else {return}
        print("data")
        cancellable=NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: NetworkingManager.handleCompletion,receiveValue:{[weak self] (globalData) in
            print("sinking")
            print(globalData.data)
            self?.marketData=globalData.data
            
               
                self?.cancellable?.cancel()
            })
            
        
    }
    
}
