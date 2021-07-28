//
//  NativeExtensions.swift
//
//  Copyright (c) 2021 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

extension UIView {
	var nearestViewController: UIViewController? {
		var responder: UIResponder? = self as UIResponder
		while responder != nil {
			if let controller = responder as? UIViewController {
				return controller
			}
			
			responder = responder?.next
		}
		
		return nil
	}
}

extension UIViewController {
	static let didDismissNotification = Notification.Name(rawValue: "pm_didDismissNotification")
	
	@objc dynamic func pm_viewDidDisappear(_ animated: Bool) {
		pm_viewDidDisappear(animated)
		if isBeingDismissed {
			NotificationCenter.default.post(name: UIViewController.didDismissNotification,
											object: self)
		}
	}
	
	static let swizzleViewDidDisappear: Void = {
		let original = #selector(UIViewController.viewDidDisappear(_:))
		let swizzled = #selector(UIViewController.pm_viewDidDisappear(_:))
		guard let originalMethod = class_getInstanceMethod(UIViewController.self, original),
			  let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzled)
		else {
			return
		}
		
		method_exchangeImplementations(originalMethod, swizzledMethod)
	}()
}
