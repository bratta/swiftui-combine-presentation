//
//  UnsplashViewModel.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI
import Combine

// Unsplash API: https://api.unsplash.com/photos/random?client_id=APPKEY&orientation=landscape&count=4

final class UnsplashViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var landscape: Images = Images()
    @Published var portrait: Images = Images()
    
    // MARK: Private attributes
    private let client_id: String = "APPKEY"
    
    // AnyCancellable is a type-erasing cancellable object that executes a closure when the
    // particular action is cancelled. This allows for cleanup on deinitialization and processes
    // to be interrupted safely at any time.
    private var cancellable: AnyCancellable?
       
    
    // MARK: Initializer
    init() {
        random(count: 4)
    }
    
    // MARK: Public Functions
    func random(count: Int) {
        // This is done just to avoid duplication of code since the first part of building
        // up the publishers is the exact same steps. Due to the generics in how these declarative
        // steps are returned it does make things a bit messy to abstract.
        let landscapePublisher = buildPublisherFor(orientation: "landscape")
        let portraitPublisher = buildPublisherFor(orientation: "portrait")

        // Publishers.Zip is a publisher that "applies the zip function to two upstream publishers".
        // I.e. this is a way to combine two publishing calls without cancelling one to start
        // the next, or dealing with callback hell for calls not necessarily dependent on each other.
        self.cancellable = Publishers.Zip(landscapePublisher, portraitPublisher)
            // This call wraps the publisher to AnyPublisher instead of the publisher's actual
            // type, allowing it to be cancellable.
            .eraseToAnyPublisher()
            // "sink" is our subscriber function that receives two closures: the completion
            // and the value of the return call. Since we are uzing Publishers.Zip, we end up
            // getting a tuple for our value, but still the one block for completion giving us
            // the ability to handle the overall success/failure of the operation.
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
                
            }, receiveValue: { landscapeModel, portraitModel in
                // This is kind of like a "join" that is executed when all the
                // processes have completed. So we'll have the result from both
                // API calls available at this time.
                self.updateImages(for: "landscape", from: landscapeModel)
                self.updateImages(for: "portrait", from: portraitModel)
            })
    }
    
    // MARK: Private Functions
    private func buildPublisherFor(orientation: String, count: Int = 4) -> Publishers.Decode<Publishers.TryMap<URLSession.DataTaskPublisher, Data>, Array<UnsplashElement>, JSONDecoder> {
        let url = "https://api.unsplash.com/photos/random?client_id=\(client_id)&orientation=\(orientation)&count=\(count)"

        // URLSession has a publisher for it's sessions, making it easy to subscribe
        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            // Like a normal map operation, but has the ability to throw an exception. In this case
            // we will either return the "data" from the request, (the raw JSON data), or throw
            // an exception using our custom HTTPError enum (see the Unsplash.swift model file)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            // Decode is another transformation step. This allows us to use an arbitrary Decoder (in this case,
            // JSONDecoder), to transform our raw JSON data returned in the tryMap step into a fully-realized
            // model class (what we'd typically call a ViewModel).
            .decode(type: Unsplash.self, decoder: JSONDecoder())
    }
    
    private func updateImages(for orientation: String, from model: [UnsplashElement]) {
        // Array provides a publisher. Assign to _ since we don't care about the return value
        _ = model.publisher
            // Just use a normal map as we're not throwing exceptions, and build up an
            // array of strings that contain the image URLs from the Unsplash API.
            .map { element in
                element.urls.regular
            }
            // Transform that array into an array of tuple-like arrays.
            .collect(2)
            // Turn that tuple-like array into an array of tuples.
            .collect()
            // Our subscriber function. What we'll do is build up an Images
            // object from our tuple array based on the orientation we've passed
            // into this function, and update the Published variable with the proper
            // object. We have to do this on the main thread since we're updating the
            // underlying published attribute.
            .sink { urls in
                DispatchQueue.main.async {
                    if orientation == "landscape" {
                        self.landscape = Images(from: urls)
                    } else {
                        self.portrait = Images(from: urls)
                    }
                }
            }
    }
}
