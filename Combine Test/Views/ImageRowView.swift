//
//  ImageRowView.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI
import Combine

struct ImageRowView: View {
    @State private var selected: Int? = 0
    
    var body: some View {
        var images: [[Int]] = []
        
        // Create a publisher from the sequence
        // This is a variable that is a Publisher.Sequence
        _ = (1...18).publisher
            // Collect 2 values from the sequence
            // And return a single array. So [1,2], then [3,4] ...
            .collect(2)
            // Now return a single array of all the sequences
            // So [[1,2], [3,4], ... [17,18]]
            .collect()
            // sink is our subscriber function, designating the
            // end of the chain. We will store the 2D array
            // inside the images variable
            .sink(receiveValue: { images = $0 })
        
        // Now we will use SwiftUI's ForEach to return an HStack
        // for every element in the outer array.
        return ForEach(0..<images.count, id: \.self) { array in
            HStack {
                // Now we loop over each element in the inner array
                // And return an Image.
                ForEach(images[array], id: \.self) { number in
                    VStack {
                        NavigationLink(destination: ImageDetailView(imageName: "unsplash\(self.selected ?? 1)"), tag: number, selection: self.$selected) {
                            // There's a bug putting the Image in here directly; Right now the Navigation Link will affect
                            // the entire HStack row so if you click on one, it will show the image but then go back and show
                            // the other image. So instead we'll rely on this navigation link firing when "tag == selection"
                            // as per the docs.
                            EmptyView()
                        }
                        Image("unsplash\(number)")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(color: Color(UIColor.systemGray3), radius: 4, x: 0, y: 0)
                            .onTapGesture {
                                // When the image is tapped, we set the $selected state variable
                                // to the image number, which will fire the Navigation Link with the proper tag.
                                self.selected = number
                            }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageRowView()
    }
}
