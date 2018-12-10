//
//  UIKit+Dequequereusable.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
	
	func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
		
		guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			return T()
		}
		
		return cell
	}
}

