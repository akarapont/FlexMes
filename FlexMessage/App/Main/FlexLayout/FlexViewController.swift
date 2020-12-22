//
//  FlexViewController.swift
//  FlexMessage
//
//  Created by Adisorn Chatnaratanakun on 18/12/2563 BE.
//

import UIKit
import SwiftyJSON

private enum Constant {
    static let flexCellId = "FlexLayoutCollectionViewCell"
}

class FlexViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellFlexHeightText: CGFloat = 50.0
    var cellFlexHeightButton: CGFloat = 50.0
    var cellFlexHeightImage: CGFloat = 200.0
    
    var renderJSON: JSON = []
    
    var renderFooterJSON: JSON = []
    var reload : Int = 0
    
    let rawDataJSON: JSON = [
        "type": "carousel",
        "contents": [
          [
            "type": "bubble",
            "header": [
              "type": "box",
              "layout": "horizontal",
              "flex": 0,
              "contents": [
                [
                  "type": "text",
                  "text": "hello, world",
                  "contents": [
                    [
                      "type": "span",
                      "text": "hello, world 2."
                    ],
                    [
                      "type": "span",
                      "text": "hello, world 31627836172637162371623781263."
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
                  "spacing": "sm",
                  "margin": "lg",
                  "contents": [
                    [
                      "type": "box",
                      "layout": "baseline",
                      "spacing": "sm",
                      "contents": [
                        [
                          "type": "text",
                          "text": "Date",
                          "size": "sm",
                          "color": "#AAAAAA",
                          "flex": 1,
                          "align": "start",
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
          ],
          [
            "type": "bubble",
            "hero": [
              "type": "image",
              "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/01_2_restaurant.png",
              "size": "full",
              "aspectRatio": "20:13",
              "aspectMode": "cover",
              "action": [
                "type": "uri",
                "label": "Action",
                "uri": "https://linecorp.com"
              ]
            ],
            "body": [
              "type": "box",
              "layout": "vertical",
              "spacing": "md",
              "action": [
                "type": "uri",
                "label": "Action",
                "uri": "https://linecorp.com"
              ],
              "contents": [
                [
                  "type": "text",
                  "text": "Brown's Burger",
                  "weight": "bold",
                  "size": "xl",
                  "contents": []
                ],
                [
                  "type": "box",
                  "layout": "vertical",
                  "spacing": "sm",
                  "contents": [
                    [
                      "type": "box",
                      "layout": "baseline",
                      "contents": [
                        [
                          "type": "icon",
                          "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/restaurant_regular_32.png"
                        ],
                        [
                          "type": "text",
                          "text": "$10.5",
                          "weight": "bold",
                          "margin": "sm",
                          "contents": []
                        ],
                        [
                          "type": "text",
                          "text": "400kcl",
                          "size": "sm",
                          "color": "#AAAAAA",
                          "align": "end",
                          "contents": []
                        ]
                      ]
                    ],
                    [
                      "type": "box",
                      "layout": "baseline",
                      "contents": [
                        [
                          "type": "icon",
                          "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/restaurant_large_32.png"
                        ],
                        [
                          "type": "text",
                          "text": "$15.5",
                          "weight": "bold",
                          "flex": 0,
                          "margin": "sm",
                          "contents": []
                        ],
                        [
                          "type": "text",
                          "text": "550kcl",
                          "size": "sm",
                          "color": "#AAAAAA",
                          "align": "end",
                          "contents": []
                        ]
                      ]
                    ]
                  ]
                ],
                [
                  "type": "text",
                  "text": "Sauce, Onions, Pickles, Lettuce & Cheese",
                  "size": "xxs",
                  "color": "#AAAAAA",
                  "wrap": true,
                  "contents": [
                    [
                      "type": "span",
                      "text": "hello, world123"
                    ],
                    [
                      "type": "span",
                      "text": "hello, worldcgfgfghfghfghfghfghfgfgfghf"
                    ]
                  ]
                ]
              ]
            ],
            "footer": [
              "type": "box",
              "layout": "vertical",
              "contents": [
                [
                  "type": "spacer",
                  "size": "xxl"
                ],
                [
                  "type": "button",
                  "action": [
                    "type": "uri",
                    "label": "Add to Cart",
                    "uri": "https://linecorp.com"
                  ],
                  "color": "#905C44",
                  "style": "primary"
                ]
              ]
            ]
          ],
          [
            "type": "bubble",
            "header": [
              "type": "box",
              "layout": "horizontal",
              "contents": [
                [
                  "type": "text",
                  "text": "NEWS DIGEST",
                  "weight": "bold",
                  "size": "sm",
                  "color": "#AAAAAA",
                  "contents": []
                ]
              ]
            ],
            "hero": [
              "type": "image",
              "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/01_4_news.png",
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
              "layout": "horizontal",
              "spacing": "md",
              "contents": [
                [
                  "type": "box",
                  "layout": "vertical",
                  "flex": 1,
                  "contents": [
                    [
                      "type": "image",
                      "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/02_1_news_thumbnail_1.png",
                      "gravity": "bottom",
                      "size": "sm",
                      "aspectRatio": "4:3",
                      "aspectMode": "cover"
                    ],
                    [
                      "type": "image",
                      "url": "https://scdn.line-apps.com/n/channel_devcenter/img/fx/02_1_news_thumbnail_2.png",
                      "margin": "md",
                      "size": "sm",
                      "aspectRatio": "4:3",
                      "aspectMode": "cover"
                    ]
                  ]
                ],
                [
                  "type": "box",
                  "layout": "vertical",
                  "flex": 2,
                  "contents": [
                    [
                      "type": "text",
                      "text": "7 Things to Know for Today",
                      "size": "xs",
                      "flex": 1,
                      "gravity": "top",
                      "contents": []
                    ],
                    [
                      "type": "separator"
                    ],
                    [
                      "type": "text",
                      "text": "Hay fever goes wild",
                      "size": "xs",
                      "flex": 2,
                      "gravity": "center",
                      "contents": []
                    ],
                    [
                      "type": "separator"
                    ],
                    [
                      "type": "text",
                      "text": "LINE Pay Begins Barcode Payment Service",
                      "size": "xs",
                      "flex": 2,
                      "gravity": "center",
                      "contents": []
                    ],
                    [
                      "type": "separator"
                    ],
                    [
                      "type": "text",
                      "text": "LINE Adds LINE Wallet",
                      "size": "xs",
                      "flex": 1,
                      "gravity": "bottom",
                      "contents": []
                    ]
                  ]
                ]
              ]
            ],
            "footer": [
              "type": "box",
              "layout": "horizontal",
              "contents": [
                [
                  "type": "button",
                  "action": [
                    "type": "uri",
                    "label": "More",
                    "uri": "https://linecorp.com"
                  ]
                ]
              ]
            ]
          ]
        ]
      ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
    }
    
    func setUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Constant.flexCellId, bundle: Bundle.main), forCellWithReuseIdentifier: Constant.flexCellId)
        collectionView.reloadData()
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
        
        collectionView.reloadData()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: CollectionView Delegate and DataSource
extension FlexViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataType = rawDataJSON["type"].stringValue
        switch dataType {
            case "carousel":
                return 1//rawDataJSON["contents"].count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataType = rawDataJSON["type"].stringValue
        switch dataType {
            case "carousel":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.flexCellId, for: indexPath) as! FlexLayoutCollectionViewCell
                cell.jsonData = rawDataJSON["contents"][indexPath.row]
                return cell
            default:
                return UICollectionViewCell(frame: CGRect.zero)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width, height: 700)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.flexCellId, for: indexPath) as! FlexLayoutCollectionViewCell
        return cell.sizeThatFits(CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude))
    }
    
    
}
