//
//  SongDetailViewController+HeaderFix.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

extension SongDetailViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return super.numberOfSections(in: collectionView) + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Header", for: indexPath) as! SongDetailHeaderCell
            configureHeaderCell(cell)
            return cell
        } else {
            return super.collectionView(collectionView, cellForItemAt: IndexPath(row: indexPath.row, section: indexPath.section))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
        } else {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(row: indexPath.row, section: indexPath.section))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Empty", for: indexPath)
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: IndexPath(row: indexPath.row, section: indexPath.section))
        }
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        } else {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
        }
    }
    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        } else {
            return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section)
        }
    }
}
