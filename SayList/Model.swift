//
//  Model.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let isMe: Bool
}

struct Artist {
    let id: String
    let name: String
}

struct Album {
    let id: String
    let name: String
    let artists: [Artist]
    let imageURL: URL?
}

struct Song {
    let id: String
    let title: String
    let artists: [Artist]
    let album: Album
}

struct Playlist {
    let id: String
    let title: String
    let songCount: Int
    let url: URL
    let songs: [Song]
//    let members: [User]
//    let songs: [Song]
}
