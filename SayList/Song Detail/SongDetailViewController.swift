//
//  SongDetailViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit
import MessengerKit

protocol SongDetailDisplay: Display {
    func setViewModel(_ viewModel: SongDetailViewModel)
}

struct SongDetailPresenter: Presenter {
    
    let song: Song
    let playlistID: String
    let display: SongDetailDisplay
    let messageClient: MessageClient
    
    private var messages: [[MSGMessage]]
    
    init(song: Song, playlistID: String, display: SongDetailDisplay, messageClient: MessageClient) {
        self.song = song
        self.playlistID = playlistID
        self.display = display
        self.messageClient = messageClient
        self.messages = []
    }
    
    mutating func displayWillShow() {
        messageClient.getMessages(for: song.id, in: playlistID) { messages in
            let mappedMessages = messages.enumerated().map {
                return $0.element.asMSGMessage(withID: $0.offset)
            }
            if mappedMessages.count > 0 {
                self.messages = [mappedMessages]
            }
            refreshDisplay()
        }
    }
    
    private func refreshDisplay() {
        let viewModel = SongDetailViewModel(imageFactory: { completion in
            if let imageURL = self.song.album.imageURL {
                URLSession.shared.dataTask(with: imageURL, completionHandler: { data, _, error in
                    guard let data = data, let image = UIImage(data: data) else {
                        completion(nil); return
                    }
                    completion(image)
                }).resume()
            }
        }, title: song.title, subtitle: song.artists.map { $0.name }.joined(separator: ", "), messages: messages)
        
        display.setViewModel(viewModel)
    }
    
    func userDidEnterMessage(_ text: String) {
        
    }
}

extension Message {
    func asMSGMessage(withID id: Int) -> MSGMessage {
        return MSGMessage(
            id: id,
            body: .text(content),
            user: user,
            sentAt: sentAt
        )
    }
}

extension User: MSGUser {
    var displayName: String { return name }
    var isSender: Bool { return isMe }
    var avatar: UIImage? {
        get { return nil }
        set(newValue) {}
    }
}

struct SongDetailViewModel {
    let imageFactory: (@escaping (UIImage?) -> Void) -> Void
    let title: String
    let subtitle: String
    
    var messages: [[MSGMessage]]
    
    func footerTitle(for section: Int) -> String? {
        return "Just now"
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
}


class SongDetailViewController: MSGMessengerViewController, SongDetailDisplay {
    var presenter: SongDetailPresenter!
    var headerView: SongDetailHeaderView!
    var viewModel: SongDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "SongDetailHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Empty")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Empty")
        self.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.displayWillShow()
    }
    
    func setViewModel(_ viewModel: SongDetailViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    func configureHeaderCell(_ cell: SongDetailHeaderCell) {
        guard let viewModel = viewModel else { return }
        
        cell.titleLable.text = viewModel.title
        cell.subtitleLabel.text = viewModel.subtitle
        
        viewModel.imageFactory({ image in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        })
    }
    
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        let messageText = inputView.textView!.text!
        presenter.userDidEnterMessage(messageText)
    }
}

// MARK: - MSGDataSource

extension SongDetailViewController: MSGDataSource {
    
    func numberOfSections() -> Int {
        return viewModel?.messages.count ?? 0
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return viewModel.messages[section - 1].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return viewModel.messages[indexPath.section - 1][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return viewModel.footerTitle(for: section - 1)
    }
    
    func headerTitle(for section: Int) -> String? {
        return viewModel.headerTitle(for: section - 1)
    }
    
}
