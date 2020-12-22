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
    private let padding: YGValue = 8.0
    
    var jsonData: JSON? {
        didSet {
            reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.autoresizingMask.insert(.flexibleHeight)
        contentView.autoresizingMask.insert(.flexibleWidth)
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
                let layoutTypeString = json["layout"].stringValue.lowercased()
                var layoutType: YGFlexDirection = .row
                
                //var layoutType: Flex.Direction = .row
                switch layoutTypeString {
                    case LayoutType.vertical:
                        layoutType = .column
                    case LayoutType.horizontal:
                        layoutType = .row
                    default:
                        break
                }
                
                
                flexLayoutView.configureLayout(block: { (flex) in
                    flex.isEnabled = true
                    flex.flexDirection = layoutType
                    flex.padding = self.padding
                    flex.alignItems = .flexStart

                    self.createContents(json: json["contents"])
                })
                
            default:
                break
        }
        
        flexLayoutView.yoga.applyLayout(preservingOrigin: true)
    }
}

//MARK: Component
extension FlexLayoutCollectionViewCell {
    
    func createContents(json: JSON){
        for i in 0..<json.count {
            let type = json[i]["type"].stringValue
            switch type {
                case FlexType.text:
                    createFlexText(json: json[i])
                default:
                    break
            }
        }
    }
    
    //Text
    func createFlexText(json: JSON) {
        let contents = json["contents"]
        if contents == 0 {
            let label = makeLabel(x: 0, y: 0, json: json)
            label.configureLayout { (layout) in
                layout.isEnabled = true
            }
            flexLayoutView.addSubview(label)
        }else{
            for i in 0..<contents.count {
                let label = makeLabel(x: 0, y: 0, json: contents[i])
                label.configureLayout { (layout) in
                    layout.isEnabled = true
                }
                flexLayoutView.addSubview(label)
            }
            //columnContainerView.backgroundColor = UIColor.green
            //flexLayoutView.addSubview(columnContainerView)
        }
    }
    
    func makeLabel(x: Int, y: Int, json: JSON) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(hex: json["color"].stringValue)
        label.text = json["text"].stringValue
        return label
    }
}
