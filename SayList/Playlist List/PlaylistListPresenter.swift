//
//  PlaylistListPresenter.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

protocol PlaylistListDisplay: Display {
    func setViewModel(_ viewModel: PlaylistListViewModel)
}

class PlayListListPresenter: ListPresenter {
    
    private var spotify: SpotifyClient
    private var display: PlaylistListDisplay
    private var playlists: [Playlist] = []
    private let onSelection: (Playlist) -> Void
    
    
    init(spotify: SpotifyClient, display: PlaylistListDisplay, onSelection: @escaping (Playlist) -> Void) {
        self.spotify = spotify
        self.display = display
        self.onSelection = onSelection
    }
    
    func viewDidAppear() {
        self.getPlaylists() {
            self.refreshDisplay()
        }
    }
    
    private func getPlaylists(afterSuccess: @escaping () -> Void) {
        spotify.getUserPlaylists() { result in
            switch result {
            case .success(let playlists):
                self.playlists = playlists
                afterSuccess()
            case .failure(let error):
                self.display.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func refreshDisplay() {
        let cellModels = self.playlists.map {
            SimpleCellModel(
                title: $0.title,
                subtitle: "\($0.songCount) songs"
            )
            
        }
        let viewModel = PlaylistListViewModel(cellModels: cellModels)
        
        self.display.setViewModel(viewModel)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        onSelection(playlists[indexPath.row])
    }
}
