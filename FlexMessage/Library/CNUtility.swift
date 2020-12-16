//
//  CNUtility.swift
//  FlexMessage
//
//  Created by nosDev on 16/12/2563 BE.
//

import UIKit

class CNUtility: NSObject {
	
	class func getBubbleSize(size: String) {
		switch size.lowercased() {
		case "nano":
			break
		case "micro":
			break
		case "kilo":
			break
		case "mega":
			break
		case "giga":
			break
		default:
			break
		}
	}
	
	class func getContentsSize(size: String) {
		switch size.lowercased() {
		case "xxs":
			break
		case "xs":
			break
		case "sm":
			break
		case "md":
			break
		case "lg":
			break
		case "xl":
			break
		case "xxl":
			break
		case "3xl":
			break
		case "4xl":
			break
		case "5xl":
			break
		default:
			break
		}
	}
	
	class func getTextAlignment(align: String) -> NSTextAlignment  {
		switch align.lowercased() {
		case "start":
			return .left
		case "center":
			return .center
		case "end":
			return .right
		default:
			return .center
		}
	}
	
	class func getTextWeight(weight: String) -> String  {
		switch weight.lowercased() {
		case "regular":
			return "Kanit-Regular"
		case "bold":
			return "Kanit-Medium"
		default:
			return "Kanit-Regular"
		}
	}
	
	class func getAspectMode(aspect: String) -> UIView.ContentMode  {
		switch aspect.lowercased() {
		case "fit":
			return .scaleAspectFit
		case "cover":
			return .scaleAspectFill
		default:
			return .scaleAspectFit
		}
	}
	
	class func getFooterLayout(layout: String) -> UIView.ContentMode  {
		switch layout.lowercased() {
		case "vertical":
			return .scaleAspectFit
		case "horizontal":
			return .scaleAspectFill
		default:
			return .scaleAspectFit
		}
	}
	
	
	
}
