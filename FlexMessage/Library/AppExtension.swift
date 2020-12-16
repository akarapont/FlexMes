//
//  AppExtension.swift
//  FlexMessage
//
//  Created by nosDev on 15/12/2563 BE.
//

import UIKit
import SwiftyJSON

class AppExtension: NSObject {

}

// MARK: - JSON
extension JSON{
	mutating func appendIfArray(json:JSON){
		if var arr = self.array{
			arr.append(json)
			self = JSON(arr);
		}
	}
	
	mutating func appendIfDictionary(key:String,json:JSON){
		if var dict = self.dictionary{
			dict[key] = json;
			self = JSON(dict);
		}
	}
}

// MARK: - UIColor
extension UIColor {
	convenience init?(hex: String, alpha: CGFloat = 1) {
		var chars = Array(hex.hasPrefix("#") ? hex.dropFirst() : hex[...])
		switch chars.count {
		case 3: chars = chars.flatMap { [$0, $0] }
		case 6: break
		default: return nil
		}
		self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
				green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
				 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
				alpha: alpha)
	}

	convenience init?(hexaRGBA: String) {
		var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
		switch chars.count {
		case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
		case 6: chars.append(contentsOf: ["F","F"])
		case 8: break
		default: return nil
		}
		self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
				green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
				 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
				alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
	}

	convenience init?(hexaARGB: String) {
		var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
		switch chars.count {
		case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
		case 6: chars.append(contentsOf: ["F","F"])
		case 8: break
		default: return nil
		}
		self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
				green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
				 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
				alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
	}
}

// MARK: - UIImageView
class ImageStore: NSObject {
	static let imageCache = NSCache<NSString, UIImage>()
}

extension UIImageView {
	func url(_ url: String?) {
		DispatchQueue.global().async { [weak self] in
			guard let stringURL = url, let url = URL(string: stringURL) else {
				return
			}
			func setImage(image:UIImage?) {
				DispatchQueue.main.async {
					self?.image = image
				}
			}
			let urlToString = url.absoluteString as NSString
			if let cachedImage = ImageStore.imageCache.object(forKey: urlToString) {
				setImage(image: cachedImage)
			} else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
				DispatchQueue.main.async {
					ImageStore.imageCache.setObject(image, forKey: urlToString)
					setImage(image: image)
				}
			}else {
				setImage(image: nil)
			}
		}
	}
}

// MARK: - UITableView
extension UITableView {
	
	func register(reuseNib: String) {
		
		self.register(UINib.init(nibName: reuseNib , bundle: .main),forCellReuseIdentifier: reuseNib)
		
	}
}

// MARK: - UICollectionView
extension UICollectionView {
	
	func register(reuseNib: String) {
		
		self.register(UINib.init(nibName: reuseNib , bundle: .main),forCellWithReuseIdentifier: reuseNib)
		
	}
}
