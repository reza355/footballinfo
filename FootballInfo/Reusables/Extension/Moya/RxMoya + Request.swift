//
//  RxMoya + Request.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 08/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift


extension MoyaProvider {
	
	// MARK: - Public methods
	
	func requestWithValidation(_ target: Target) -> Observable<Response> {
		
		return self.rx.request(target)
			.asObservable()
			.flatMap({ (response: Response) -> Observable<Response> in
				
				let responseSuccess: CountableRange<Int> = (200..<300)
				
				switch response.statusCode {
					
				case responseSuccess:
					
					return Observable<Response>.just(response)
					
				default:
							
					let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
					
					return Observable<Response>.error(error)
				}
			})
	}
	
}
