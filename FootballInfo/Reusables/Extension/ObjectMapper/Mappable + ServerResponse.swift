//
//  Mappable + ServerResponse.swift
//  FootballInfo
//
//  Created by Fathureza Januarza on 10/12/18.
//  Copyright © 2018 Fathureza Januarza. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya
import ObjectMapper

extension Observable where Element: Any {
	
	/// Maps the sent `Element` to `Void`. Useful if you only need the `next` event.
	func mapToVoid() -> Observable<Void> {
		
		return self.map({ _ -> Void in
			return
		})
	}
}

extension Observable where Element: OptionalType {
	
	/**
	Returns wrapped value through `next` event if the value is valid, and `error` event with parsing-related `NSError` if it's a `nil`.
	*/
	func flatMapForServerResponse() -> Observable<Element.Wrapped> {
		
		return self.flatMap { (value: Element) -> Observable<Element.Wrapped> in
			
			if let validValue = value.optionalValue {
				return Observable<Element.Wrapped>.just(validValue)
			}
			
			let parseError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to pass server response"])
			
			return Observable<Element.Wrapped>.error(parseError)
		}
	}
}

extension Observable where Element: Moya.Response {
	
	/**
	Sends `next` event if there's a valid value in passed `keyPath`, and `error` event if it's a `nil`.
	
	- note: The default value for keyPath is `data`.
	*/
	func flatMapResponseToVoid(keyPath: String? = "data") -> Observable<Void> {
		
		return self.map({ (response: Element) -> Any? in
			
			guard let JSON = try? response.mapJSON(),
				let validJSON = JSON as? [String: Any] else {
					
					return nil
			}
			
			guard let validKeyPath = keyPath else {
				return validJSON
			}
			
			return validJSON[validKeyPath]
		})
			.flatMap({ (response: Any?) -> Observable<Void> in
				
				if response != nil {
					return Observable<Void>.just(())
				}
				
				let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something wrong happened. Please try again later."])
				
				return Observable<Void>.error(error)
			})
	}
	
	/**
	Returns the passed Mappable-compliant object if mapping succeeds and `nil` if fails. Uses passed `keyPath` as root JSON source path.
	
	- note: The default keyPath is "data". Setting this to `nil` will make it take the whole response.
	*/
	func mapResponse<T: Mappable>(to type: T.Type, keyPath: String? = "data") -> Observable<T?> {
		
		return self.map { (response: Response) -> T? in
			
			guard let JSON = try? response.mapJSON(),
				let validJSON = JSON as? [String: Any] else {
					return nil
			}
			
			guard let validPath = keyPath else {
				return Mapper<T>().map(JSON: validJSON)
			}
			
			if let rawData = validJSON[validPath] as? [String: Any] {
				
				return Mapper<T>().map(JSON: rawData)
				
			} else {
				
				return nil
			}
		}
	}
	
	/**
	Returns array of Mappable object if mapping succeeds and `nil` if mapping fails. The Array of object will be taken from the passed `keyPath`.
	
	- note: The default keyPath is "data".
	*/
	func mapResponseArray<T: Mappable>(to type: T.Type, keyPath: String = "data") -> Observable<[T]?> {
		
		return self.map { (response: Response) -> [T]? in
			
			guard let JSON = try? response.mapJSON(),
				let validJSON = JSON as? [String: Any],
				let rawData = validJSON[keyPath] as? [[String: Any]] else {
					
					return nil
			}
			
			return Mapper<T>().mapArray(JSONArray: rawData)
		}
	}
	
	/**
	Sends `next` event and true and false bool value if there's a valid value in passed `keyPath`, and `error` event if it's a `nil`.
	
	- note: The default value for keyPath is `data`.
	*/
	func flatMapResponseToBool(keyPath: String = "data") -> Observable<Bool> {
		
		return self.map({ (response: Element) -> Bool? in
			
			guard let JSON = try? response.mapJSON(),
				let validJSON = JSON as? [String: Any] else {
					return nil
			}
			
			return validJSON[keyPath] as? Bool
		})
			.flatMap({ (response: Bool?) -> Observable<Bool> in
				
				guard let response = response else {
					
					let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something wrong happened. Please try again later."])
					return Observable<Bool>.error(error)
				}
				
				return Observable<Bool>.just(response)
				
			})
	}
	
	/**
	Sends `next` event with String value if there's a valid value in passed `keyPath`, and `error` event if it's a `nil`.
	
	- note: The default value for keyPath is `data`.
	*/
	func flatMapResponseToString(keyPath: String = "data") -> Observable<String> {
		
		return self.map({ (response: Element) -> String? in
			
			guard let JSON = try? response.mapJSON(),
				let validJSON = JSON as? [String: String] else {
					return nil
			}
			return validJSON[keyPath]
		})
			.flatMap({ (response: String?) -> Observable<String> in
				
				guard let response = response else {
					
					let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something wrong happened. Please try again later."])
					return Observable<String>.error(error)
				}
				
				return Observable<String>.just(response)
				
			})
	}
	
}

