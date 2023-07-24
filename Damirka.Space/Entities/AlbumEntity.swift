//
//  AlbumEntity.swift
//  Damirka.Space
//
//  Created by Dam1rka on 20.07.2023.
//

struct AlbumEntity: Codable, Hashable {
    static func == (lhs: AlbumEntity, rhs: AlbumEntity) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.image == rhs.image &&
        lhs.albumType == rhs.albumType &&
        lhs.liked == rhs.liked
    }
    
    var id: Int
    var title: String
    var description: String
    var image: ImageEntity
    var albumType: String
    var liked: Bool
    
}
