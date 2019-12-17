//
//  TestJsonView.swift
//  Combine Test
//
//  Created by Timothy Gourley on 12/16/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI
import Combine

// Represents the JSON format: {"valid":true}
fileprivate struct PostmanEchoTimeStampCheckResponse: Decodable, Hashable {
    let valid: Bool
}

// Here's our "View Model" for validating the timestamp
final class ValidateTimeStamp: ObservableObject {
    @Published var valid: Bool
    
    // AnyCancellable is a type-erasing cancellable object that executes a closure when the
    // particular action is cancelled. This allows for cleanup on deinitialization and processes
    // to be interrupted safely at any time.
    private var cancellable: AnyCancellable?
    
    init() {
        valid = false
    }
    
    func validate(_ timestamp: String) {
        let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=\(timestamp)")
        // checks the validity of a timestamp - this one returns {"valid":true}
        // matching the data structure returned from https://postman-echo.com/time/valid

        let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL!)
            // the dataTaskPublisher output combination is (data: Data, response: URLResponse)
            .map { $0.data }
            .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())

        self.cancellable = remoteDataPublisher
            .sink(receiveCompletion: { completion in
                    print(".sink() received the completion", String(describing: completion))
                    switch completion {
                        case .finished:
                            break
                        case .failure(let anError):
                            print("received error: ", anError)
                    }
            }, receiveValue: { someValue in
                print(".sink() received \(someValue)")
                DispatchQueue.main.async {
                    self.valid = someValue.valid
                }
            })
    }
}


struct TestJsonView: View {
    @State private var date: String = "2019-12-17"
    @ObservedObject var validator = ValidateTimeStamp()
    
    var body: some View {
        VStack {
            Text("Is it valid? \(String(validator.valid))")
            TextField("Enter Date:", text: $date)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: { self.validator.validate(self.date) }) {
                Text("Validate")
            }.padding(.all)
        }.padding(.all, 40)
    }
}

struct TestJsonView_Previews: PreviewProvider {
    static var previews: some View {
        TestJsonView()
    }
}
