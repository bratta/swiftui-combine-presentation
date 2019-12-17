//
//  RemoteImageLoaderViewModel.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/24/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI
import Combine

final class RemoteImageLoaderViewModel: ObservableObject {
    @Published var image: UIImage?
    
    var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) {
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .sink(receiveCompletion: { completion in
                // You might not need this check. Your use case
                // may allow you to swallow exceptions and have a null
                // value for the published image variable so you can
                // display a default image instead.
                
                //switch completion {
                //case .failure(let error):
                //    print(error)
                //case .finished:
                //    print("Finished receiving image!")
                //}
            }, receiveValue: { data, response in
                // Why do we have (data, response) as arguments to the closure?
                // It's because we're using the default from the dataTaskPublisher
                // and not mapping the data in any custom way, unlike what we're doing
                // in the UnsplashViewModel.
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            })
    }
}
