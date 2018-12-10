//
//  NavigationScreen.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import UIKit

struct NavigationScreen<T: Equatable> {
	let screen: T
	let viewController: UIViewController
}

extension NavigationScreen: Equatable {
	
	static func ==(lhs: NavigationScreen, rhs: NavigationScreen) -> Bool {
		
		let sameScreen = lhs.screen == rhs.screen
		let sameViewController = lhs.viewController === rhs.viewController
		
		return sameScreen && sameViewController
	}
}
