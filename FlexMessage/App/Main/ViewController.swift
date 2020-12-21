//
//  ViewController.swift
//  FlexMessage
//
//  Created by nosDev on 15/12/2563 BE.
//

import UIKit
import SwiftyJSON

enum CellFlexType: String {
	case flexText = "text"
	case flexButton = "button"
	case flexImage = "image"
	case flexBox = "box"
	case flexIcon = "icon"
}

enum MainReuseNibFlexCell: String {
	case flexText = "CNFlexMessageTextCell"
	case flexButton = "CNFlexMessageButtonCell"
	case flexImage = "CNFlexMessageImageCell"
	case flexBox = "CNFlexMessageBoxCell"
}

class ViewController: UIViewController {
	
	@IBOutlet weak var flexBGView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	var cellFlexHeightText: CGFloat = 50.0
	var cellFlexHeightButton: CGFloat = 50.0
	var cellFlexHeightImage: CGFloat = 200.0
	
	var renderJSON: JSON = []
	
	var renderFooterJSON: JSON = []
	
	let rawDataJSON: JSON = [
		"type": "bubble",
        "header": [
            "type": "box",
            "layout": "vertical",
            "flex": 0,
            "contents": [
              [
                "type": "text",
                "text": "hello, world",
                "contents": [
                  [
                    "type": "span",
                    "text": "hello, world 1.  "
                  ],
                  [
                    "type": "span",
                    "text": "hello, world"
                  ]
                ]
              ]
            ]
          ],
		"hero": [
			"type": "image",
			"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/01_3_movie.png",
			"size": "full",
			"aspectRatio": "20:13",
			"aspectMode": "cover",
			"action": [
				"type": "uri",
				"label": "Action",
				"uri": "https://linecorp.com/"
			]
		],
		"body": [
			"type": "box",
			"debug": "1",
			"layout": "vertical",
			"spacing": "md",
			"contents": [
				[
					"type": "text",
					"text": "BROWN'S ADVENTURE\nIN MOVIE",
					"weight": "bold",
					"size": "xl",
					"gravity": "center",
					"wrap": true,
					"contents": []
				],
				[
					"type": "box",
					"layout": "baseline",
					"margin": "md",
					"contents": [
						[
							"type": "icon",
							"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png",
							"size": "sm"
						],
						[
							"type": "icon",
							"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png",
							"size": "sm"
						],
						[
							"type": "icon",
							"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png",
							"size": "sm"
						],
						[
							"type": "icon",
							"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png",
							"size": "sm"
						],
						[
							"type": "icon",
							"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gray_star_28.png",
							"size": "sm"
						],
						[
							"type": "text",
							"text": "4.0",
							"size": "sm",
							"color": "#999999",
							"flex": 0,
							"margin": "md",
							"contents": []
						]
					]
				],
				[
					"type": "box",
					"layout": "vertical",
					"debug": "2",
					"spacing": "sm",
					"margin": "lg",
					"contents": [
						[
							"type": "box",
							"layout": "baseline",
							"debug": "3",
							"spacing": "sm",
							"contents": [
								[
									"type": "text",
									"text": "Date",
									"size": "sm",
									"color": "#AAAAAA",
									"flex": 1,
									"contents": []
								],
								[
									"type": "text",
									"text": "Monday 25, 9:00PM",
									"size": "sm",
									"color": "#666666",
									"flex": 4,
									"wrap": true,
									"contents": []
								]
							]
						],
						[
							"type": "box",
							"layout": "baseline",
							"spacing": "sm",
							"debug": "3",
							"contents": [
								[
									"type": "text",
									"text": "Place",
									"size": "sm",
									"color": "#AAAAAA",
									"flex": 1,
									"contents": []
								],
								[
									"type": "text",
									"text": "7 Floor, No.3",
									"size": "sm",
									"color": "#666666",
									"flex": 4,
									"wrap": true,
									"contents": []
								]
							]
						],
						[
							"type": "box",
							"layout": "baseline",
							"spacing": "sm",
							"debug": "3",
							"contents": [
								[
									"type": "text",
									"text": "Seats",
									"size": "sm",
									"color": "#AAAAAA",
									"flex": 1,
									"contents": []
								],
								[
									"type": "text",
									"text": "C Row, 18 Seat",
									"size": "sm",
									"color": "#666666",
									"flex": 4,
									"wrap": true,
									"contents": []
								]
							]
						]
					]
				],
				[
					"type": "box",
					"layout": "vertical",
					"margin": "xxl",
					"contents": [
						[
							"type": "spacer"
						],
						[
							"type": "image",
							"url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/linecorp_code_withborder.png",
							"size": "xl",
							"aspectMode": "cover"
						],
						[
							"type": "text",
							"text": "You can enter the theater by using this code instead of a ticket",
							"size": "xs",
							"color": "#AAAAAA",
							"margin": "xxl",
							"wrap": true,
							"contents": []
						]
					]
				]
			]
		]
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUp()
		setUpUI()
		convertJSONFlex()
	}
	
	func setUp() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		
		tableView.register(reuseNib: MainReuseNibFlexCell.flexText.rawValue)
		tableView.register(reuseNib: MainReuseNibFlexCell.flexButton.rawValue)
		tableView.register(reuseNib: MainReuseNibFlexCell.flexImage.rawValue)
		tableView.register(reuseNib: MainReuseNibFlexCell.flexBox.rawValue)
	}
	
	func setUpUI() {
		flexBGView.layer.cornerRadius = 12
	}
	
	func convertJSONFlex(){
		//header
        if rawDataJSON["header"] != JSON.null {
            renderJSON.appendIfArray(json: rawDataJSON["header"])
        }
		
		//hero
        if rawDataJSON["header"] != JSON.null {
            renderJSON.appendIfArray(json: rawDataJSON["hero"])
        }
		
		//body
        if rawDataJSON["body"] != JSON.null {
            renderJSON.appendIfArray(json: rawDataJSON["body"])
        }
		
		//footer
        if rawDataJSON["footer"] != JSON.null {
            renderJSON.appendIfArray(json: rawDataJSON["footer"])
        }
		
		tableView.reloadData()
	}
	
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return renderJSON.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = renderJSON[indexPath.row]
		switch data["type"].stringValue {
		case CellFlexType.flexText.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: MainReuseNibFlexCell.flexText.rawValue, for: indexPath) as? CNFlexMessageTextCell {
				cell.cellLabel.text = data["text"].stringValue
				cell.cellLabel.textAlignment = CNUtility.getTextAlignment(align: data["align"].stringValue)
				cell.isUserInteractionEnabled = false
				cell.selectionStyle = .none
				return cell
			}
			return UITableViewCell(frame: .zero)
		case CellFlexType.flexButton.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: MainReuseNibFlexCell.flexButton.rawValue, for: indexPath) as? CNFlexMessageButtonCell {
				cell.cellButton.setTitle(data["action"]["label"].stringValue, for: .normal)
				cell.cellButton.backgroundColor = UIColor(hexaRGBA: data["color"].stringValue)
				cell.cellButton.layer.cornerRadius = 12
				cell.isUserInteractionEnabled = false
				cell.selectionStyle = .none
				return cell
			}
			return UITableViewCell(frame: .zero)
		case CellFlexType.flexImage.rawValue, CellFlexType.flexIcon.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: MainReuseNibFlexCell.flexImage.rawValue, for: indexPath) as? CNFlexMessageImageCell {
				cell.cellImageView.url(data["url"].stringValue)
				cell.cellImageView.contentMode = CNUtility.getAspectMode(aspect: data["aspectMode"].stringValue)
				return cell
			}
			return UITableViewCell(frame: .zero)
		case CellFlexType.flexBox.rawValue:
			if let cell = tableView.dequeueReusableCell(withIdentifier: MainReuseNibFlexCell.flexBox.rawValue) as? CNFlexMessageBoxCell {
				cell.rawJSON = data
				cell.setUp()
				return cell
			}
			return UITableViewCell(frame: .zero)
		default:
			return UITableViewCell(frame: .zero)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let data = renderJSON[indexPath.row]
		switch data["type"].stringValue {
		case CellFlexType.flexText.rawValue:
			return UITableView.automaticDimension
		case CellFlexType.flexButton.rawValue:
			return cellFlexHeightButton
		case CellFlexType.flexImage.rawValue:
			return cellFlexHeightImage
		case CellFlexType.flexBox.rawValue:
			return UITableView.automaticDimension
		default:
			return 0
		}
	}
}

