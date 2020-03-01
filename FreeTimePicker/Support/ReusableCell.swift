//
//  ReusableCell.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/03/01.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension Reusable where Self: UITableViewCell {
    static func reuse(_ tableView: UITableView, at indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as! Self
    }
}

extension Reusable where Self: UICollectionViewCell {
    static func reuse(_ collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath) as! Self
    }
}
