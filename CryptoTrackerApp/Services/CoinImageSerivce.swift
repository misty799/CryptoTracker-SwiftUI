//
//  CoinImageSerivce.swift
//  CryptoTrackerApp
//
//  Created by apple on 23/11/22.
//

import Foundation
import SwiftUI
import Combine
class CoinImageService{
    @Published var image:UIImage?=nil
    var cancellable:AnyCancellable?
    private let fileManager:LocalFileMananger=LocalFileMananger.instance
    private let coin:CoinModel
    private let folderName="coin_image"
    init(coin:CoinModel){
        self.coin=coin
        getCoinImage()
        
    }
    private func getCoinImage(){
        if let savedImage=fileManager.getImage(imageName:coin.id , folderName:folderName
        ){
            image=savedImage
            print("Retrieved image from file manager")
        }
        else {
            downloadCoinImage()
        }
        
    }
    private func downloadCoinImage(){
        print("downloading image now")
        guard let url=URL(string:coin.image) else {return}
            cancellable=NetworkingManager.download(url: url)
                .tryMap{(data)->UIImage? in
                        return UIImage(data:data)
                }
                .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: NetworkingManager.handleCompletion,receiveValue:{[weak self] (returnedImage) in
            guard let self=self ,
                  let downloadImage=returnedImage else {
                      return
                  }
        
                self.image=downloadImage
            self.fileManager.saveImage(image:downloadImage, imageName:self.coin.id, folderName:self.folderName)
            
                self.cancellable?.cancel()
            })

        
    }
}
