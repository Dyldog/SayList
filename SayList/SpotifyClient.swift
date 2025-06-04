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
    
    private func authorizedRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeRequest<T>(for url: URL, completion: @escaping (Result<T, Swift.Error>) -> Void) where T: Decodable {
        let request = authorizedRequest(for: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else { completion(.failure(error!)); return }
            
            guard let data = data else { completion(.failure(Error.noData)); return}
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch  {
                print(String(data: data, encoding: .utf8)!)
                completion(.failure(Error.couldntDecodeData(error)))
                return
            }
        }.resume()
    }
    
    private func handleResponse<DataType, DomainType>(result: Result<DataType, Swift.Error>, completion: (Result<DomainType, Swift.Error>) -> Void) where DataType: DomainMappable, DataType.DomainType == DomainType {
        switch result {
        case .success(let value):
            completion(.success(value.asDomainType()))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func getResource<DataType>(at url: URL, ofType dataType: DataType.Type, completion: @escaping (Result<DataType.DomainType, Swift.Error>) -> Void) where DataType: DomainMappable, DataType: Decodable {
        makeRequest(for: url, completion: { (networkResult: Result<DataType, Swift.Error>)  in
            self.handleResponse(
                result: networkResult,
                completion: {
                    completion($0)
            })
        })
    }
    
    private func string(at url: URL, completion: (String) -> Void) {
        let request = authorizedRequest(for: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            print(String(data: data!, encoding: .utf8)!)
        }.resume()
    }
    
    func getUserPlaylists(completion: @escaping (Result<[Playlist], Swift.Error>) -> Void) {
        getResource(
            at: URL(string: "https://api.spotify.com/v1/me/playlists")!,
            ofType: SAPIPagedResponse<[SAPIUnloadedPlaylist]>.self,
            completion: completion
        )
    }
    
    func getPlaylistSongs(for id: String, completion: @escaping (Result<Playlist, Swift.Error>) -> Void) {
        getResource(at: URL(string: "https://api.spotify.com/v1/playlists/\(id)")!, ofType: SAPILoadedPlaylist.self, completion: completion)
    }
}

extension SAPIUnloadedPlaylist: DomainMappable {
    func asDomainType() -> Playlist {
        return Playlist(id: self.id, title: self.name, songCount: self.tracks.total, url: URL(string: self.href)!, songs: [])
    }
}

extension SAPILoadedPlaylist: DomainMappable {
    func asDomainType() -> Playlist {
        return Playlist(id: self.id, title: self.name, songCount: self.tracks.total, url: URL(string: self.href)!, songs: self.tracks.asDomainType())
    }
}

extension SAPILoadedPagedResource: DomainMappable where T: DomainMappable {
    func asDomainType() -> T.DomainType {
        return items.asDomainType()
    }
}

extension SAPIPagedResponse: DomainMappable where T: DomainMappable {
    func asDomainType() -> T.DomainType {
        return items.asDomainType()
    }
}

extension Array: DomainMappable where Element: DomainMappable {
    func asDomainType() -> [Element.DomainType] {
        return map { $0.asDomainType() }
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sAPIResponse = try? newJSONDecoder().decode(SAPIResponse.self, from: jsonData)

protocol SAPIPagedResource {
    var href: String { get }
    var total: Int { get }
}

class SAPIUnloadedPagedResource: Codable, SAPIPagedResource {
    let href: String
    let total: Int
    
    init(href: String, total: Int){
        self.href = href
        self.total = total
    }
}

class SAPILoadedPagedResource<T>: SAPIPagedResource, Codable where T: Codable {
    let href: String
    let total: Int
    let items: T
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    
    init(href: String, total: Int, items: T, limit: Int, next: String?, offset: Int, previous: String?) {
        self.href = href
        self.total = total
        self.items = items
        self.limit = limit
        self.next = next
        self.offset = offset
        self.previous = previous
    }
}

// MARK: - SAPIResponse
struct SAPIPagedResponse<T>: Codable where T: Codable {
    let href: String
    let items: T
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

// MARK: - SAPIItem
class SAPIPlaylist<Tracks>: Codable where Tracks: Codable {
    
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

class SAPIUnloadedPlaylist: SAPIPlaylist<SAPIUnloadedPagedResource> {}
class SAPILoadedPlaylist: SAPIPlaylist<SAPILoadedPagedResource<[SAPITrackItem]>> {}

// MARK: - SAPIExternalUrls
struct SAPIExternalUrls: Codable {
    let spotify: String
}

// MARK: - SAPIImage
struct SAPIImage: Codable {
    let height: Int
    let url: String
    let width: Int
}

// MARK: - SAPIOwner
struct SAPIOwner: Codable {
    let displayName: String?
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

// MARK: - SAPIOwner
struct SAPIArtist: Codable {
    let name: String
    let externalUrls: SAPIExternalUrls
    let href: String
    let id: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case uri = "uri"
    }
}

extension SAPIArtist: DomainMappable {
    func asDomainType() -> Artist {
        return Artist(id: self.id, name: self.name)
    }
}

protocol DomainMappable {
    associatedtype DomainType
    func asDomainType() -> DomainType
}

// MARK: - SAPIItem
struct SAPITrackItem: Codable {
    let addedAt: String
    let addedBy: SAPIOwner
    let isLocal: Bool
    let track: SAPITrack
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case track = "track"
    }
}

extension SAPITrack: DomainMappable {
    func asDomainType() -> Song {
        return Song(id: self.id, title: self.name, artists: self.artists.asDomainType(), album: album.asDomainType())
    }
}

extension SAPITrackItem: DomainMappable {
    func asDomainType() -> Song {
        return track.asDomainType()
    }
}

// MARK: - SAPITrack
struct SAPITrack: Codable {
    let album: SAPIAlbum
    let artists: [SAPIArtist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMS: Int
    let episode: Bool
    let explicit: Bool
    let externalUrls: SAPIExternalUrls
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewURL: String?
    let track: Bool
    let trackNumber: Int
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case album = "album"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case episode = "episode"
        case explicit = "explicit"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case isLocal = "is_local"
        case name = "name"
        case popularity = "popularity"
        case previewURL = "preview_url"
        case track = "track"
        case trackNumber = "track_number"
        case uri = "uri"
    }
}

// MARK: - SAPIAlbum
struct SAPIAlbum: Codable {
    let artists: [SAPIArtist]
    let availableMarkets: [String]
    let externalUrls: SAPIExternalUrls
    let href: String
    let id: String
    let images: [SAPIImage]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case artists = "artists"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case uri = "uri"
    }
}

extension SAPIAlbum: DomainMappable {
    func asDomainType() -> Album {
        return Album(
            id: self.id, name: self.name,
            artists: self.artists.asDomainType(),
            imageURL: (images.max { $0.width < $1.width }?.url).lift({ URL(string: $0) }) ?? nil
        )
    }
}

extension Optional {
    func lift<OUT>(_ work: (Wrapped) -> OUT) -> OUT? {
        if let self = self {
            return work(self)
        } else {
            return nil
        }
    }
}
