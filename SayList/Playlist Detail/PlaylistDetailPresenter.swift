//
//  PlaylistDetailPresenter.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

protocol PlaylistDetailDisplay: Display {
    func setViewModel(_ viewModel: PlaylistDetailViewModel)
}

class PlaylistDetailPresenter: ListPresenter {
    let display: PlaylistDetailDisplay
    var playlist: Playlist
    let spotify: SpotifyClient
    let onSelection: (Song) -> Void
    
    init(spotify: SpotifyClient, playlist: Playlist, display: PlaylistDetailDisplay, onSelection: @escaping (Song) -> Void) {
        self.spotify = spotify
        self.playlist = playlist
        self.display = display
        self.onSelection = onSelection
    }
    
    func displayWillShow() {
        getSongs {
            self.refreshDisplay()
        }
    }
    
    private func getSongs(afterSuccess: @escaping () -> Void) {
        spotify.getPlaylistSongs(for: playlist.id, completion: { result in
            switch result {
            case .success(let playlist):
                self.playlist = playlist
                afterSuccess()
            case .failure(let error):
                self.display.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func refreshDisplay() {
        let cellModels = playlist.songs.map {
            return SimpleCellModel(
                title: $0.title,
                subtitle: $0.artists.map { $0.name }.joined(separator: ", ")
            )
        }
        
        let viewModel = PlaylistDetailViewModel(cellModels: cellModels)
        
        display.setViewModel(viewModel)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        onSelection(playlist.songs[indexPath.row])
    }
}
