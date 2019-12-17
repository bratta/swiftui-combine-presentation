//
//  ImageDetailView.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI

struct ImageDetailView: View {
    @State var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(imageName: "unsplash1")
    }
}
