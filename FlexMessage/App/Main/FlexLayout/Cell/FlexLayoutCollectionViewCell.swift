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
    static let icon: String = "icon"
    static let spacer: String = "spacer"
    static let button: String = "button"
    static let separator: String = "separator"
}

private enum LayoutType {
    static let horizontal: String = "horizontal"
    static let vertical: String = "vertical"
    static let baseline: String = "baseline"
}

private enum Constant {
    static let backgroundIdentifier : Int = 14123124123
}

class FlexLayoutCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var flexLayoutView: UIView!
    private let padding: CGFloat = 8.0
    
    
    var jsonData: JSON? {
        didSet {
            removeAllSubviews()
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        flexLayoutView.frame = frame
        print("Check cell frame size: \(frame)")
        setupCell()
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.autoresizingMask.insert(.flexibleHeight)
        flexLayoutView.frame = frame
        print("Check cell frame size: \(frame)")
        setupCell()
        reloadData()
    }
    
    func removeAllSubviews(){
        for view in flexLayoutView.subviews {
            view.removeFromSuperview()
        }
    }
}

//MARK: Layout
extension FlexLayoutCollectionViewCell {
    func setupCell(){
        removeAllSubviews()
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
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        flexLayoutView.layer.cornerRadius = 12
        flexLayoutView.clipsToBounds = true
        
        flexLayoutView.flex.addItem().define { (flex) in
            flex.direction(.column)
            let header = json["header"]
            if header != JSON.null {
                self.checkFlexType(flex: flex, json: header)
            }
            let hero = json["hero"]
            if hero != JSON.null {
                self.checkFlexType(flex: flex, json: hero)
            }
            let body = json["body"]
            if body != JSON.null {
                self.checkFlexType(flex: flex, json: body)
            }
            let footer = json["footer"]
            if footer != JSON.null {
                self.checkFlexType(flex: flex, json: footer)
            }
        }
        flexLayoutView.flex.layout(mode: .fitContainer)
        setNeedsLayout()
    }
    
    func checkBackgroudSubview(){
        let view = UIView(frame: self.bounds)
        view.tag = Constant.backgroundIdentifier
        for subview in self.subviews {
            if subview.tag == Constant.backgroundIdentifier {
                subview.removeFromSuperview()
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    let view = UIView(frame: self.bounds)
                    view.tag = Constant.backgroundIdentifier
                    view.backgroundColor = UIColor.white
                    view.layer.cornerRadius = 12
                    self.addSubview(view)
                    self.sendSubviewToBack(view)
                }
            }
        }
    }
}

//MARK: Component
extension FlexLayoutCollectionViewCell {
    
    func checkFlexType(flex: Flex, json: JSON) {
        let type = json["type"].stringValue.lowercased()
        switch type {
            case FlexType.box:
                let flexBoxView = createFlexBox(json: json)
                flexBoxView.tag = 11111
                flex.addItem(flexBoxView).shrink(1)
                //flexLayoutView.addSubview(flexBoxView)
            case FlexType.image:
                createFlexImage(flex: flex, json: json)
                //flexLayoutView.addSubview(flexImageView)
            default:
                break
        }
    }
    
    func createContents(flex: Flex, json: JSON) {
        for i in 0..<json.count {
            let type = json[i]["type"].stringValue
            switch type {
                case FlexType.text:
                    if let view = flex.view {
                        let flexText = createFlexText(contentView: view, json: json[i])
                        flex.addItem(flexText).shrink(1)
                    }
                case FlexType.image:
                    createFlexImage(flex: flex, json: json[i])
                case FlexType.icon:
                    let flexIcon = createFlexIcon(json: json[i])
                    flex.addItem(flexIcon)
                case FlexType.box:
                    let flexBoxView = createFlexBox(json: json[i])
                    flexBoxView.tag = 22222
                    flexBoxView.clipsToBounds = true
                    flex.addItem(flexBoxView).shrink(1).layout(mode: .fitContainer)
                case FlexType.button:
                    let flexButton = createFlexButton(json: json[i])
                    flex.addItem(flexButton)
                case FlexType.separator:
                    let flexSeperator = createFlexSeparator(json: json[i])
                    flex.addItem(flexSeperator)
                    break
                default:
                    break
            }
        }
    }
}

//MARK: Flex Box
extension FlexLayoutCollectionViewCell {
    func createFlexBox(json: JSON) -> UIView {
        let contents = json["contents"]
        let layoutTypeString = json["layout"].stringValue.lowercased()
        var layoutType: Flex.Direction = .row
        
        switch layoutTypeString {
            case LayoutType.vertical:
                layoutType = .column
            case LayoutType.horizontal:
                layoutType = .row
            default:
                break
        }
        
        let containerView = UIView(frame: .zero)
        containerView.flex.addItem().define { (flex) in
            
            flex.direction(layoutType)
            flex.padding(8)
            flex.markDirty()
            flex.justifyContent(.start)
            
            if layoutTypeString == LayoutType.baseline {
                flex.alignItems(.baseline)
            }else{
                flex.alignItems(.start)
            }
            flex.grow(CGFloat(json["flex"].intValue))
            self.createContents(flex: flex, json: json["contents"])
        }

        return containerView
    }
}

//MARK: Flex Text
extension FlexLayoutCollectionViewCell {
    func createFlexText(contentView: UIView, json: JSON) -> UIView{
        let view = UIView(frame: .zero)
        view.flex.define({
            (layout) in
            layout.direction(.row)
            layout.margin(12)
            layout.justifyContent(.start)
        
            var isWrap = false
            if json["wrap"].boolValue {
                layout.wrap(.wrap)
                isWrap = true
            }else{
                layout.wrap(.noWrap)
            }
            
            let contents = json["contents"]
            if contents.count == 0 {
                let label = self.makeLabel(x: 0, y: 0, json: json)
                if isWrap {
                    label.numberOfLines = 0
                }
                layout.addItem(label).shrink(1)
            }else{
                for i in 0..<contents.count {
                    let label = self.makeLabel(x: 0, y: 0, json: contents[i])
                    if isWrap {
                        label.numberOfLines = 0
                    }
                    layout.addItem(label).shrink(1)
                }
            }
        })
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

//MARK: Flex Image
extension FlexLayoutCollectionViewCell {
    func createFlexImage(flex: Flex, json: JSON) {
        flex.define { (layout) in
            let episodeImageView = UIImageView(frame: .zero)
            episodeImageView.backgroundColor = .white
            
            let image = UIImage(named: json["url"].stringValue)
            episodeImageView.image = image
            let imageWidth = image?.size.width ?? 1.0
            let imageHeight = image?.size.height ?? 1.0
            
            let aspectRatio = json["aspectRatio"].stringValue
            episodeImageView.flex.define { (layout) in
                layout.grow(CGFloat(json["flex"].intValue))
                if aspectRatio != "" {
                    let seperateString = aspectRatio.split(separator: ":")
                    let width = String(seperateString.first ?? "1")
                    let height = String(seperateString.last ?? "1")
                    layout.aspectRatio(CGFloat(Int(width) ?? 1) / CGFloat(Int(height) ?? 1))
                }else{
                    let ratio = imageWidth/imageHeight
                    layout.aspectRatio(ratio)
                }
            }
            layout.markDirty()
            layout.addItem(episodeImageView).shrink(1)
        }
    }
}

//MARK: Flex Icon
extension FlexLayoutCollectionViewCell {
    func createFlexIcon(json: JSON) -> UIView {
        let view = UIView(frame: .zero)
        view.flex.define { (layout) in
            let episodeImageView = UIImageView(frame: .zero)
            episodeImageView.backgroundColor = .white
            
            let image = UIImage(named: json["url"].stringValue)
            episodeImageView.image = image
            
            let imageWidth = image?.size.width ?? 1.0
            let imageHeight = image?.size.height ?? 1.0
            
            let aspectRatio = json["aspectRatio"].stringValue
            episodeImageView.flex.define { (layout) in
                layout.grow(CGFloat(json["flex"].intValue))
                if aspectRatio != "" {
                    let seperateString = aspectRatio.split(separator: ":")
                    let width = String(seperateString.first ?? "1")
                    let height = String(seperateString.last ?? "1")
                    layout.aspectRatio(CGFloat(Int(width) ?? 1) / CGFloat(Int(height) ?? 1))
                }else{
                    let ratio = imageWidth/imageHeight
                    layout.aspectRatio(ratio)
                    layout.markDirty()
                }
            }
            layout.markDirty()
            layout.addItem(episodeImageView).shrink(1)
        }
        return view
    }
}

//MARK: Spacer
extension FlexLayoutCollectionViewCell {
    func createFlexSpacer() -> UIView {
        let view = UIView(frame: .zero)
        view.configureLayout { (layout) in
            layout.isEnabled = true
        }
        return view
    }
}

//MARK: Seperator
extension FlexLayoutCollectionViewCell {
    func createFlexSeparator(json: JSON) -> UIView {
        let view = UIView(frame: .zero)
        let margin: CGFloat = self.padding * 2
        let width = self.frame.width - margin
        
        let color = json["color"].stringValue
        if color != ""{
            view.backgroundColor = UIColor.init(hex: color)
        }else{
            view.backgroundColor = .systemGroupedBackground
        }
        view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(width)
            layout.height = 1
        }
        return view
    }
}

//MARK: Button
extension FlexLayoutCollectionViewCell {
    func createFlexButton(json: JSON) -> UIView{
        let view = UIView(frame: .zero)
        let margin: CGFloat = self.padding * 2
        let width = self.frame.width - margin
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(width)
        }
        let button = UIButton(frame: .zero)
        button.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = 50
            layout.width = YGValue(width)
        }
        let action = json["action"]
        button.setTitle(action["label"].stringValue, for: .normal)
        
        let color = json["color"].stringValue
        if color != "" {
        button.backgroundColor = UIColor(hex: color)
        }else{
            button.backgroundColor = .white
        }
        
        let style = json["style"].stringValue
        if style == "primary" {
            button.setTitleColor(UIColor.white, for: .normal)
        }else{
            button.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        
        view.addSubview(button)
        return view
    }
}
