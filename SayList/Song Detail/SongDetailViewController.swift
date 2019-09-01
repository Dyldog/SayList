//
//  SongDetailViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

protocol SongDetailDisplay: Display {
    func setViewModel(_ viewModel: SongDetailViewModel)
}

struct SongDetailPresenter: Presenter {
    let song: Song
    let display: SongDetailDisplay
    
    private var messages: [[MSGMessage]] = {
        let steve = ChatUser(displayName: "Steve", avatar: nil, avatarURL: nil, isSender: true)
        let tim = ChatUser(displayName: "Tim", avatar: nil, avatarURL: nil, isSender: false)
        
        return [
            [MSGMessage(id: 1, body: .emoji("🐙💦🔫"), user: tim, sentAt: Date()),],
            [MSGMessage(id: 2, body: .text("Yeah sure, gimme 5"), user: steve, sentAt: Date()),
             MSGMessage(id: 3, body: .text("Okay ready when you are"), user: steve, sentAt: Date())]
        ]
    }()
    
    init(song: Song, display: SongDetailDisplay) {
        self.song = song
        self.display = display
    }
    
    func displayWillShow() {
        refreshDisplay()
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

import MessengerKit

struct ChatUser: MSGUser {
    let displayName: String
    var avatar: UIImage?
    let avatarURL: URL?
    let isSender: Bool
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
