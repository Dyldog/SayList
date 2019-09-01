//
//  Model.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
}

struct Artist {
    let id: String
    let name: String
}

struct Album {
    let id: String
    let name: String
    let artist: Artist
    let songs: [Song]
}

struct Song {
    let id: String
    let title: String
    let artist: Artist
    let album: Album
}

struct Playlist {
    let id: String
    let title: String
    let songCount: Int
//    let members: [User]
//    let songs: [Song]
}
