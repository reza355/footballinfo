//
//  OptionalType.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation

protocol OptionalType {
	
	associatedtype Wrapped
	
	func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension OptionalType {
	
	/**
	Proxy property to allow extensions use Optional normally.
	*/
	var optionalValue: Wrapped? {
		
		return self.map { (value: Wrapped) -> Wrapped in
			return value
		}
	}
}
