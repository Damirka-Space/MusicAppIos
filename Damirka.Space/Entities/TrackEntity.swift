//
//  TrackEntity.swift
//  Damirka.Space
//
//  Created by Dam1rka on 20.07.2023.
//

struct TrackEntity: Codable {
    var id: Int
    var title: String
    var author: [String]
    var albumId: Int
    var album: String
    var url: String
    var imageUrl: String
    var metadataImageUrl: String
    var liked: Bool
}
