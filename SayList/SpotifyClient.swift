//
//  SpotifyClient.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

class SpotifyClient {
    enum Error: Swift.Error {
        case noData
        case couldntDecodeData(Swift.Error)
    }
    
    let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func getUserPlaylists(completion: @escaping (Result<[Playlist], Swift.Error>) -> Void) {
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else { completion(.failure(error!)); return }
            
            guard let data = data else { completion(.failure(Error.noData)); return}
            
            do {
                let response = try JSONDecoder().decode(SAPIResponse<[SAPIPlaylist]>.self, from: data)
                completion(.success(response.items.map { $0.asDomainType() }))
            } catch  {
                print(String(data: data, encoding: .utf8))
                completion(.failure(Error.couldntDecodeData(error)))
                return
            }
        
        }.resume()
    }
}

extension SAPIPlaylist {
    func asDomainType() -> Playlist {
        return Playlist(id: self.id, title: self.name, songCount: self.tracks.total)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sAPIResponse = try? newJSONDecoder().decode(SAPIResponse.self, from: jsonData)

// MARK: - SAPIResponse
struct SAPIResponse<T>: Decodable where T: Decodable {
    let href: String
    let items: T
    let limit: Int
    let next: String
    let offset: Int
    let previous: String?
    let total: Int
}

// MARK: - SAPIItem
struct SAPIPlaylist: Decodable {
    struct Tracks: Decodable {
        let href: String
        let total: Int
    }
    
    let collaborative: Bool
    let externalUrls: SAPIExternalUrls
    let href: String
    let id: String
    let images: [SAPIImage]
    let name: String
    let owner: SAPIOwner
    let isPublic: Bool
    let snapshotID: String
    let tracks: Tracks
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case collaborative = "collaborative"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case owner = "owner"
        case isPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks = "tracks"
        case uri = "uri"
    }
}

// MARK: - SAPIExternalUrls
struct SAPIExternalUrls: Decodable {
    let spotify: String
}

// MARK: - SAPIImage
struct SAPIImage: Decodable {
    let height: Int
    let url: String
    let width: Int
}

// MARK: - SAPIOwner
struct SAPIOwner: Decodable {
    let displayName: String
    let externalUrls: SAPIExternalUrls
    let href: String
    let id: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case uri = "uri"
    }
}
