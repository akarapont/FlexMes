//
//  FlexLayoutCollectionViewCell.swift
//  FlexMessage
//
//  Created by Adisorn Chatnaratanakun on 18/12/2563 BE.
//

import UIKit
import FlexLayout
import SwiftyJSON
import PinLayout

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flexLayoutView.frame = frame
        setupCell()
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        // Initialization code
    //        contentView.autoresizingMask.insert(.flexibleHeight)
    //        contentView.autoresizingMask.insert(.flexibleWidth)
    //        setupCell()
    //    }
}

//MARK: Layout
extension FlexLayoutCollectionViewCell {
    func setupCell(){
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        layout(size: bounds.size)
    //    }
    //
    //    fileprivate func layout(size: CGSize) {
    //        flex.size(size).layout()
    //    }
    //
    //    override func sizeThatFits(_ size: CGSize) -> CGSize {
    //        contentView.pin.width(size.width)
    //        layout(size: CGSize(width: size.width != .greatestFiniteMagnitude ? size.width : 10000,
    //                            height: size.height != .greatestFiniteMagnitude ? size.height : 10000))
    //        return CGSize(width: size.width, height: contentView.frame.height + 4)
    //    }
    //
    //    override var intrinsicContentSize: CGSize {
    //        return sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude))
    //    }
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
        
        flexLayoutView.configureLayout { (flex) in
            flex.isEnabled = true
            flex.flexDirection = .column
            
            let header = json["header"]
            if header != JSON.null {
                self.setFlexHeader(json: header)
            }
            let hero = json["hero"]
            if hero != JSON.null {
                self.setFlexHero(json: hero)
            }
            let body = json["body"]
            if body != JSON.null {
                self.setFlexBody(json: body)
            }
            
            flex.markDirty()
        }
        flexLayoutView.yoga.applyLayout(preservingOrigin: true)
        setNeedsLayout()
    }
    
    //MARK: Flex Header
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
                
                let headerView = UIView(frame: .zero)
                headerView.pin.width(contentView.frame.width)
                headerView.configureLayout(block: {
                    (flex) in
                    flex.isEnabled = true
                    flex.flexDirection = layoutType
                    flex.padding = self.padding
                    flex.alignItems = .flexStart
                    
                    let contentViews = self.createContents(headerView: headerView, json: json["contents"])
                    for view in contentViews {
                        self.flexLayoutView.addSubview(view)
                    }
                })
            default:
                break
        }
    }
    
    //MARK: Flex Hero
    func setFlexHero(json: JSON){
        let episodeImageView = UIImageView(frame: .zero)
        episodeImageView.backgroundColor = .gray
        // 2
        let image = UIImage(named: json["url"].stringValue)
        episodeImageView.image = image
        // 3
        let imageWidth = image?.size.width ?? 1.0
        let imageHeight = image?.size.height ?? 1.0
        // 4
        episodeImageView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexGrow = 1.0
            layout.aspectRatio = imageWidth / imageHeight
        }
        flexLayoutView.addSubview(episodeImageView)
    }
    
    func setFlexBody(json: JSON){
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
                
                let headerView = UIView(frame: .zero)
                headerView.pin.width(contentView.frame.width)
                headerView.configureLayout(block: {
                    (flex) in
                    flex.isEnabled = true
                    flex.flexDirection = layoutType
                    flex.padding = self.padding
                    flex.alignItems = .flexStart
                    
                    let contentViews = self.createContents(headerView: headerView, json: json["contents"])
                    for view in contentViews {
                        self.flexLayoutView.addSubview(view)
                    }
                })
            default:
                break
        }
    }
}

//MARK: Component
extension FlexLayoutCollectionViewCell {
    
    func createContents(headerView: UIView, json: JSON) -> [UIView] {
        var views = [UIView]()
        for i in 0..<json.count {
            let type = json[i]["type"].stringValue
            switch type {
                case FlexType.text:
                    views.append(createFlexText(headerView: headerView, json: json[i]))
                default:
                    break
            }
        }
        return views
    }
    
    //Text
    func createFlexText(headerView: UIView, json: JSON) -> UIView{
        let view = UIView(frame: .zero)
        view.pin.width(contentView.frame.width)
        view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.margin = 8
            
            var isWrap = false
            if json["wrap"].boolValue {
                layout.flexWrap = .wrap
                isWrap = true
            }else{
                layout.flexWrap = .noWrap
            }
            
            let contents = json["contents"]
            if contents.count == 0 {
                let label = self.makeLabel(x: 0, y: 0, json: json)
                if isWrap {
                    label.numberOfLines = 0
                }
                label.configureLayout { (layout) in
                    layout.isEnabled = true
                }
                view.addSubview(label)
            }else{
                for i in 0..<contents.count {
                    let label = self.makeLabel(x: 0, y: 0, json: contents[i])
                    if isWrap {
                        label.numberOfLines = 0
                    }
                    label.configureLayout { (layout) in
                        layout.isEnabled = true
                    }
                    view.addSubview(label)
                }
            }
        }
        return view
    }
    
    func makeLabel(x: Int, y: Int, json: JSON) -> UILabel {
        let label = UILabel(frame: .zero)
        if json["color"].stringValue != "" {
            label.textColor = UIColor.init(hex: json["color"].stringValue)
        }
        label.text = json["text"].stringValue
        label.lineBreakMode = .byTruncatingTail
        
        let weight = json["weight"].stringValue
        switch weight {
            case "bold":
                label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                label.numberOfLines = 0
            default:
                break
        }
        return label
    }
}
