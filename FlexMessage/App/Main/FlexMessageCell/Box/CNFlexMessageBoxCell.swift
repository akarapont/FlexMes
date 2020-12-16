//
//  CNFlexMessageBoxCell.swift
//  FlexMessage
//
//  Created by nosDev on 16/12/2563 BE.
//

import UIKit
import SwiftyJSON

enum BoxReuseNibFlexCell: String {
	case flexText = "CNFlexMessageTextCollCell"
	case flexButton = "CNFlexMessageButtonCollCell"
	case flexImage = "CNFlexMessageImageCollCell"
	case flexBox = "CNFlexMessageBoxCollCell"
}

enum CNFlexMessageBoxCellLayout: String {
	case vertical = "vertical"
	case horizontal = "horizontal"
}

class CNFlexMessageBoxCell: UITableViewCell {

	@IBOutlet weak var cellCollectionView: UICollectionView!
	@IBOutlet weak var cellCollectionViewHeight: NSLayoutConstraint!
	
	var cellFlexHeightText: CGFloat = 50.0
	var cellFlexHeightButton: CGFloat = 50.0
	var cellFlexHeightImage: CGFloat = 200.0
	var cellFlexHeightBox: CGFloat = 50.0
	var cellFlexHeightIcon: CGFloat = 20
	
	var rawJSON: JSON = []
	var renderJSON: JSON = []
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setUp() {
		cellCollectionView.delegate = self
		cellCollectionView.dataSource = self
		cellCollectionView.isUserInteractionEnabled = false

		cellCollectionView.register(reuseNib: BoxReuseNibFlexCell.flexText.rawValue)
		cellCollectionView.register(reuseNib: BoxReuseNibFlexCell.flexButton.rawValue)
		cellCollectionView.register(reuseNib: BoxReuseNibFlexCell.flexImage.rawValue)
		cellCollectionView.register(reuseNib: BoxReuseNibFlexCell.flexBox.rawValue)
		
		convertJsonToUI()
		updateHeightCollection()
	}
	
	func convertJsonToUI(){
		let layout = rawJSON["layout"].stringValue
		if layout.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
			if let layout = cellCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
				layout.scrollDirection = .vertical
			}
		}else{
			if let layout = cellCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
				layout.scrollDirection = .horizontal
			}
		}
		renderJSON = rawJSON["contents"]
		cellCollectionView.reloadData()
	}
	
	func updateHeightCollection() {
		var height:CGFloat = 0.0
		let layout = rawJSON["layout"].stringValue
		if layout.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
			for item in rawJSON["contents"].arrayValue {
				if item["layout"].stringValue.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
					switch item["type"].stringValue {
					case CellFlexType.flexText.rawValue:
						height += cellFlexHeightText
						break
					case CellFlexType.flexButton.rawValue:
						height += cellFlexHeightButton
						break
					case CellFlexType.flexImage.rawValue:
						height += cellFlexHeightImage
						break
					case CellFlexType.flexIcon.rawValue:
						height += cellFlexHeightIcon
						break
					case CellFlexType.flexBox.rawValue:
						let layout = item["layout"].stringValue
						if layout.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
							for itemBox in item["contents"].arrayValue {
								if itemBox["layout"].stringValue.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
									switch itemBox["type"].stringValue {
									case CellFlexType.flexText.rawValue:
										height += cellFlexHeightText
										break
									case CellFlexType.flexIcon.rawValue:
										height += cellFlexHeightIcon
										break
									case CellFlexType.flexBox.rawValue:
										for itemBoxInBox in itemBox["contents"].arrayValue {
											if itemBoxInBox["layout"].stringValue.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
												switch itemBoxInBox["type"].stringValue {
												case CellFlexType.flexText.rawValue:
													height += cellFlexHeightText
													cellFlexHeightBox += cellFlexHeightText
													break
												case CellFlexType.flexIcon.rawValue:
													height += cellFlexHeightIcon
													cellFlexHeightBox += cellFlexHeightIcon
													break
												default:
													break
												}
											}else {
												height += cellFlexHeightBox
											}
										}
										break
									default:
										break
									}
								}else {
									height += cellFlexHeightBox
								}
							}
						}else {
							height += cellFlexHeightBox
						}
						break
					default:
						break
					}
				} else{
					height += cellFlexHeightBox
				}
			}
		}else{
			height = 50
		}
		cellCollectionViewHeight.constant = height
	}
    
}

extension CNFlexMessageBoxCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return renderJSON.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let data = renderJSON[indexPath.row]
		switch data["type"].stringValue {
		case CellFlexType.flexText.rawValue:
			if let cell = cellCollectionView.dequeueReusableCell(withReuseIdentifier: BoxReuseNibFlexCell.flexText.rawValue, for: indexPath) as? CNFlexMessageTextCollCell {
				cell.cellLabel.text = data["text"].stringValue
				cell.cellLabel.textAlignment = CNUtility.getTextAlignment(align: data["align"].stringValue)
				cell.isUserInteractionEnabled = false
				return cell
			}
			return UICollectionViewCell(frame: .zero)
		case CellFlexType.flexButton.rawValue:
			if let cell = cellCollectionView.dequeueReusableCell(withReuseIdentifier: BoxReuseNibFlexCell.flexButton.rawValue, for: indexPath) as? CNFlexMessageButtonCollCell {
				cell.cellButton.setTitle(data["action"]["label"].stringValue, for: .normal)
				cell.cellButton.backgroundColor = UIColor(hexaRGBA: data["color"].stringValue)
				cell.cellButton.layer.cornerRadius = 12
				cell.isUserInteractionEnabled = false
				return cell
			}
			return UICollectionViewCell(frame: .zero)
		case CellFlexType.flexImage.rawValue, CellFlexType.flexIcon.rawValue:
			if let cell = cellCollectionView.dequeueReusableCell(withReuseIdentifier: BoxReuseNibFlexCell.flexImage.rawValue, for: indexPath) as? CNFlexMessageImageCollCell {
				cell.cellImageView.url(data["url"].stringValue)
				cell.cellImageView.contentMode = CNUtility.getAspectMode(aspect: data["aspectMode"].stringValue)
				return cell
			}
			return UICollectionViewCell(frame: .zero)
		case CellFlexType.flexBox.rawValue:
			if let cell = cellCollectionView.dequeueReusableCell(withReuseIdentifier: BoxReuseNibFlexCell.flexBox.rawValue, for: indexPath) as? CNFlexMessageBoxCollCell {
				cell.rawJSON = data
				return cell
			}
			return UICollectionViewCell(frame: .zero)
		default:
			return UICollectionViewCell(frame: .zero)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let layout = rawJSON["layout"].stringValue
		let contents = rawJSON["contents"]
		if layout.lowercased() == CNFlexMessageBoxCellLayout.vertical.rawValue {
			let data = renderJSON[indexPath.row]
			switch data["type"].stringValue {
			case CellFlexType.flexText.rawValue:
				return CGSize(width: self.frame.width, height: cellFlexHeightText)
			case CellFlexType.flexButton.rawValue:
				return CGSize(width: self.frame.width, height: cellFlexHeightButton)
			case CellFlexType.flexImage.rawValue:
				return CGSize(width: self.frame.width, height: cellFlexHeightImage)
			case CellFlexType.flexIcon.rawValue:
				return CGSize(width: self.frame.width, height: cellFlexHeightIcon)
			case CellFlexType.flexBox.rawValue:
				return CGSize(width: self.frame.width, height: cellFlexHeightBox)
			default:
				return CGSize(width: 0, height: 0)
			}
		}else{
			return CGSize(width: Int(self.cellCollectionView.frame.width) / contents.count, height: 50)
		}
	}
}
