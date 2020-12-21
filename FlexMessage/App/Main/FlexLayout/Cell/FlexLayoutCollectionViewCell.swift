//
//  FlexLayoutCollectionViewCell.swift
//  FlexMessage
//
//  Created by Adisorn Chatnaratanakun on 18/12/2563 BE.
//

import UIKit
import FlexLayout
import SwiftyJSON

private enum FlexType {
    static let box: String = "box"
    static let text: String = "text"
    static let image: String = "image"
}

private enum LayoutType {
    static let horizontal: String = "horizontal"
    static let vertical: String = "vertical"
}

class FlexLayoutCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var flexLayoutView: UIView!
    
    var jsonData: JSON? {
        didSet {
            reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
}

//MARK: Layout
extension FlexLayoutCollectionViewCell {
    func setupCell(){
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout(size: bounds.size)
    }
    
    fileprivate func layout(size: CGSize) {
        flex.size(size).layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout(size: CGSize(width: size.width != .greatestFiniteMagnitude ? size.width : 10000,
                            height: size.height != .greatestFiniteMagnitude ? size.height : 10000))
        return CGSize(width: size.width, height: contentView.frame.height + 4)
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude))
    }
}

extension FlexLayoutCollectionViewCell {
    func reloadData(){
        if let json = jsonData {
            setFlexView(json: json)
        }
    }
}

//MARK: Create Flex View
extension FlexLayoutCollectionViewCell {
    func setFlexView(json: JSON){
        
        let header = json["header"]
        if header != JSON.null {
            setFlexHeader(json: header)
        }
    
        setNeedsLayout()
    }
    
    func setFlexHeader(json: JSON){
        let type = json["type"].stringValue.lowercased()
        switch type {
            case FlexType.box:
                let contents = json["contents"]
                let layoutType = json["layout"].stringValue.lowercased()
                switch layoutType {
                    case LayoutType.vertical:
                        let rowContainer = UIView()
                        rowContainer.flex.direction(.row).define {
                            (flex) in
//                            if contents.count > 0 {
//                                createContents(flex: flex, json: contents)
//                            }
                            let label1 = UILabel()
                            label1.text = "Text 1"
                            label1.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
                            
                            let label2 = UILabel()
                            label2.text = "Text 2"
                            label2.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
                            
                            let rowContainer = UIView()
                            rowContainer.flex.direction(.row)
                            rowContainer.flex.addItem(label1).grow(1)
                            rowContainer.flex.addItem(label2)
                            
                            flex.addItem(rowContainer)
                        }
                        contentView.flex.addItem(rowContainer)
                        
                    default:
                        break
                }
            default:
                break
        }
    }
}

//MARK: Component
extension FlexLayoutCollectionViewCell {
    
    func createContents(flex: Flex ,json: JSON){
        for i in 0..<json.count {
            let type = json[i]["type"].stringValue
            switch type {
                case FlexType.text:
                    createFlexText(flex: flex, json: json[i])
                default:
                    break
            }
        }
    }
    
    //Text
    func createFlexText(flex: Flex, json: JSON) {
        let contents = json["contents"]
        if contents == 0 {
            let label = makeLabel(x: 16, y: 0, json: json)
            flex.addItem(label).wrap(Flex.Wrap.wrap)
        }else{
            flex.addItem().direction(.column).margin(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)).define { (flex) in
                for i in 0..<contents.count {
                    let label = makeLabel(x: 16, y: 0, json: contents[i])
                    flex.addItem(label).wrap(Flex.Wrap.wrap)
                }
            }
        }
    }
    
    func makeLabel(x: Int, y: Int, json: JSON) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.init(hex: json["color"].stringValue)
        label.text = json["text"].stringValue
        label.frame = CGRect(x: x, y: y, width: 200, height: 50)
        return label
    }
}
