//
//  Reuseidentifier.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

/**
- note: To use this in reusable nib register, in the register(collectionViewCell: T.type) just change the T.type to CellClassName.self
*/
protocol ReusableView: class {}

extension ReusableView {
	static var nib: UINib {
		
		let bundle = Bundle.init(for: self)
		return UINib(nibName: reuseIdentifier, bundle: bundle)
	}
	
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

extension UICollectionViewCell: ReusableView {}
