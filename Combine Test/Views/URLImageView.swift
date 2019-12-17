//
//  URLImageView.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI

struct URLImageView: View {    
    @ObservedObject private var remoteImageLoaderViewModel = RemoteImageLoaderViewModel()
    
    init(url: String) {
        print("Instantiating URLImageView with: \(url)")
        remoteImageLoaderViewModel.loadImage(from: URL(string: url)!)
    }
    
    var body: some View {
        Image(uiImage: self.remoteImageLoaderViewModel.image ?? UIImage(systemName: "photo")!)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .shadow(color: Color(UIColor.systemGray3), radius: 4, x: 0, y: 0)
    }
}
