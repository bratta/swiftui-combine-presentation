//
//  OrientationViewModel.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/17/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import SwiftUI

final class OrientationViewModel: ObservableObject {
    public static let shared = OrientationViewModel()
    
    @Published var isLandscape: Bool = false
    
    private init() { self.isLandscape = false }
}
