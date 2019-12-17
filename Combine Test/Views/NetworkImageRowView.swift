//
//  NetworkImageRowView.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI
import Combine

struct NetworkImageRowView: View {
    @ObservedObject var orientation = OrientationViewModel.shared
    @ObservedObject var unsplash = UnsplashViewModel()
    
    var body: some View {
        VStack {
            if (orientation.isLandscape) {
                ImageListView(unsplashImages: $unsplash.landscape)
            } else {
                ImageListView(unsplashImages: $unsplash.portrait)
            }
        }
        .padding()
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ImageListView: View {
    @Binding var unsplashImages: Images
    
    var body: some View {
        ForEach(unsplashImages.all, id: \.self) { row in
             HStack {
                ForEach(row.images, id: \.self) { col in
                     VStack {
                         URLImageView(url: col.url)
                     }
                 }
            }
         }
    }
}

struct NetworkImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        return NetworkImageRowView()
    }
}
