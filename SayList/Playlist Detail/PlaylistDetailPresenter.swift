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
    
    init(spotify: SpotifyClient, playlist: Playlist, display: PlaylistDetailDisplay) {
        self.spotify = spotify
        self.playlist = playlist
        self.display = display
    }
    
    func viewDidAppear() {
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
            return SimpleCellModel(title: $0.title, subtitle: nil)
        }
        
        let viewModel = PlaylistDetailViewModel(cellModels: cellModels)
        
        display.setViewModel(viewModel)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
}
