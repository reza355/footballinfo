//
//  TeamLogoCell.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

final class TeamLogoCell: UICollectionViewCell {
	
	@IBOutlet private var teamLogo: UIImageView!
	
	private var viewModel: TeamLogoCellViewModel?
	private let disposeBag = DisposeBag()
	
	func bind(viewModel: TeamLogoCellViewModel) {
		
		self.viewModel = viewModel
		showLogo(viewModel: viewModel)
	}
	
	func showLogo(viewModel: TeamLogoCellViewModel) {
		
		viewModel.logoURL.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (logoURL: String) in
				
				let imageURL = URL(string: logoURL)
				self?.teamLogo.sd_setImage(with: imageURL)
			})
			.disposed(by: disposeBag)
	}
}
