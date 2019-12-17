//
//  LandscapesView.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI

struct LandscapesView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ImageRowView()
                //NetworkImageRowView()
            }
            .navigationBarTitle(Text("Landscapes"))
        }
        .border(Color.clear, width: 0)
    }
}

struct LandscapesView_Previews: PreviewProvider {
    static var previews: some View {
        LandscapesView()
    }
}
