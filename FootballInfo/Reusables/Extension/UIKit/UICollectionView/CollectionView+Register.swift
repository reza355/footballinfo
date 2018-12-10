//
//  CollectionView+Register.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
	
	func register<T: UICollectionViewCell>(collectionViewCell: T.Type) {
		
		register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
	}
}
