//
//  UINavigationController+TransitionDelegate.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: UINavigationControllerDelegate {
	
	// MARK: - Public methods
	
	func push(viewController: UIViewController, animated: Bool) {
		pushViewController(viewController, animated: animated)
	}
	
	func pop(animated: Bool) {
		popViewController(animated: animated)
	}
}
