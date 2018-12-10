//
//  TeamDetailViewController.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import UIKit
import RxSwift

final class TeamDetailViewController: UIViewController {
	
	@IBOutlet private var formedYear: UILabel!
	@IBOutlet private var stadiumName: UILabel!
	@IBOutlet private var desc: UITextView!
	
	private var viewModel: TeamDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

		bindViewModel()
    }
	
	convenience init(viewModel: TeamDetailViewModel) {
		self.init()
		
		self.viewModel = viewModel
	}
	
	
	private func bindViewModel() {
		
		viewModel?.teamDetail.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (team: FootballTeam) in
				
				self?.formedYear.text = team.formedYear
				self?.stadiumName.text = team.stadiumName
				self?.desc.text = team.teamDescription
			})
			.disposed(by: disposeBag)
	}
}
