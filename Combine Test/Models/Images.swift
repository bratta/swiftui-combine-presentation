//
//  Images.swift
//  Combine Test
//
//  Created by Timothy Gourley on 10/24/19.
//  Copyright © 2019 Timothy Gourley. All rights reserved.
//

import Foundation

struct ImageColumn: Decodable, Identifiable, Hashable {
    let id = UUID()
    let url: String
    
    init(_ str: String) { url = str }
}

struct ImageRow: Decodable, Identifiable, Hashable {
    let id = UUID()
    let images: [ImageColumn]
    
    init(_ arr: [ImageColumn]) { images = arr }
}

struct Images: Decodable, Identifiable, Hashable {
    let id = UUID()
    let all: [ImageRow]
    
    init() { all = [] }
    init(_ arr: [ImageRow]) { all = arr }
    
    init(from nestedArray: [[String]]) {
        all = Images.buildImageRows(from: nestedArray)
    }
    
    private static func buildImageRows(from images: [[String]]) -> [ImageRow] {
        var imageRowArray: [ImageRow] = []
        images.forEach { row in
            var imageColumnArray: [ImageColumn] = []
            row.forEach { col in
                let imageColumn = ImageColumn(col)
                imageColumnArray.append(imageColumn)
            }
            imageRowArray.append(ImageRow(imageColumnArray))
        }
        return imageRowArray
    }
}
