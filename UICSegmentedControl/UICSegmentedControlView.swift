//
//  UICSegmentedControlView.swift
//  UICSegmentedControlView
//
//  Created by Coder ACJHP on 13.04.2019.
//  Copyright © 2019 Onur Işık. All rights reserved.
//

import UIKit

@objc protocol UICSegmentedControlDelegate: class {
    func segmentedControlView(_ segmentedControlView: UICSegmentedControlView, didSelectedIndex: Int)
}

@IBDesignable
class UICSegmentedControlView: UIView {
    
    @IBInspectable
    public var bgColor: UIColor = .purple {
        didSet {
            commonInit()
        }
    }
    
    @IBInspectable
    public var selectionBarColor: UIColor = .lightGray {
        didSet {
            setupSelectionBar()
        }
    }
    
    @IBInspectable
    public var selectionBarTitleColor: UIColor = .lightGray {
        didSet {
            generateStackView()
        }
    }
    
    @IBInspectable
    public var cornerRadiuss: CGFloat = 0 {
        didSet {
            commonInit()
            setupSelectionBar()
        }
    }
    
    @IBInspectable
    public var isShadowed: Bool = true {
        didSet {
            commonInit()
        }
    }
    
    @IBInspectable
    public var selectionBarTitleFont: UIFont = .boldSystemFont(ofSize: 16) {
        didSet {
            generateStackView()
        }
    }
    
    public var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex < segmentsTitleList.count {
                let btn = UIButton()
                btn.tag = selectedIndex
                self.handleButtonPress(btn)
            }
        }
    }
    
    
    private let containerView = UIView()
    private var leftRightMargin: CGFloat = 10
    private var selectionBar: UIView?
    private var selectionBarWidth: CGFloat = 0
    private var selectionBarHeight: CGFloat = 0
    private var segmentsTitleList: [String] = []
    
    private var selectionBarTrailingConstraint: NSLayoutConstraint?
    private var selectionBarLeadingConstraint: NSLayoutConstraint?
    
    
    private var buttonsList: [UIButton] = []
    private var buttonsStackView: UIStackView?
    
    weak var delegate: UICSegmentedControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, titleList: [String]) {
        self.init(frame: frame)
        segmentsTitleList = titleList
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView() {
        commonInit()
        setupSelectionBar()
        generateStackView()
    }
    
    private func commonInit() {
        
        if self.isShadowed {
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = cornerRadiuss
            layer.shadowColor = bgColor.cgColor
            layer.shadowOpacity = 0.4

        } else {
            layer.shadowOffset = .zero
            layer.shadowRadius = 0
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 0
        }
        
        layer.borderWidth = 2
        layer.cornerRadius = cornerRadiuss
        layer.borderColor = bgColor.darker(by: 5)?.cgColor

        
        selectionBarWidth = (frame.width / CGFloat(segmentsTitleList.count))
        selectionBarHeight = frame.height
        
        containerView.frame = self.bounds
        containerView.backgroundColor = bgColor
        containerView.layer.cornerRadius = cornerRadiuss
        containerView.layer.masksToBounds = true
        
        insertSubview(containerView, at: 0)
        
        // Add notification observer to handle orientation change
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrientationChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    fileprivate func setupSelectionBar() {
        
        if selectionBar != nil {
            selectionBar?.removeFromSuperview()
            selectionBar = nil
        }
        
        selectionBar = UIView(frame: CGRect(x: 0, y: 0, width: selectionBarWidth, height: selectionBarHeight))
        selectionBar!.layer.cornerRadius = cornerRadiuss
        selectionBar!.backgroundColor = selectionBarColor
        selectionBar!.layer.borderWidth = 2
        selectionBar!.layer.cornerRadius = cornerRadiuss
        selectionBar!.layer.borderColor = bgColor.darker(by: 5)?.cgColor
        selectionBar!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectionBar!)
        
        
        selectionBarLeadingConstraint = selectionBar!.leadingAnchor.constraint(equalTo: leadingAnchor)
        selectionBarLeadingConstraint?.isActive = true
        
        let constant = frame.width - selectionBarWidth
        selectionBarTrailingConstraint = selectionBar!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant)
        selectionBarTrailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            selectionBar!.heightAnchor.constraint(equalToConstant: selectionBarHeight),
            selectionBar!.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    fileprivate func generateStackView() {
        
        if buttonsStackView != nil {
            buttonsList.forEach { (button) in
                buttonsStackView?.removeArrangedSubview(button)
            }
            buttonsStackView?.removeFromSuperview()
            buttonsStackView = nil
        }
        
        buttonsStackView = UIStackView(arrangedSubviews: [])
        buttonsStackView!.distribution = .fillEqually
        buttonsStackView!.alignment = .fill
        buttonsStackView!.axis = .horizontal
        buttonsStackView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsStackView!)
        
        NSLayoutConstraint.activate([
            buttonsStackView!.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStackView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStackView!.topAnchor.constraint(equalTo: topAnchor),
            buttonsStackView!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        (0..<segmentsTitleList.count).forEach { (index) in
            
            let button = UIButton(type: .system)
            button.setTitle(segmentsTitleList[index], for: .normal)
            button.tintColor = index == 0 ? bgColor : selectionBarTitleColor
            button.tag = index
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.font = selectionBarTitleFont
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
            buttonsStackView!.addArrangedSubview(button)
            buttonsStackView!.layoutSubviews()
            buttonsList.append(button)
        }
    }
    
    var previousTag = 0
    
    @objc fileprivate func handleButtonPress(_ sender: UIButton) {
        
        if sender.tag > previousTag {
            
            let trailingConstant = self.frame.width - (self.selectionBarWidth * CGFloat(sender.tag + 1))
            self.selectionBarTrailingConstraint?.constant = -trailingConstant
            
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            
                            self.layoutIfNeeded()
                            self.buttonsList.forEach {
                                if $0.tag == sender.tag {
                                    $0.tintColor = self.bgColor
                                } else {
                                    $0.tintColor = self.selectionBarTitleColor
                                }
                            }
                            
            }, completion: {(_) in
                
                let constant = (self.frame.width / CGFloat(self.segmentsTitleList.count)) * CGFloat(sender.tag)
                self.selectionBarLeadingConstraint?.constant = constant
                
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1,
                               initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                                self.layoutIfNeeded()
                }, completion: nil)
                
            })
            
        } else {
            
            let constant = (self.frame.width / CGFloat(self.segmentsTitleList.count)) * CGFloat(sender.tag)
            self.selectionBarLeadingConstraint?.constant = constant
            
            UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            
                            self.layoutIfNeeded()
                            self.buttonsList.forEach {
                                if $0.tag == sender.tag {
                                    $0.tintColor = self.bgColor
                                } else {
                                    $0.tintColor = self.selectionBarTitleColor
                                }
                            }
                            
            }, completion: {(_) in

                let trailingConstant = self.frame.width - (self.selectionBarWidth * CGFloat(sender.tag + 1))
                self.selectionBarTrailingConstraint?.constant = -trailingConstant
                
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1,
                               initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                                self.layoutIfNeeded()
                }, completion: nil)
            })
        }
        
        // Swap the queue
        previousTag = sender.tag

        self.delegate?.segmentedControlView(self, didSelectedIndex: sender.tag)        
    }
    
    @objc private func handleOrientationChange() {
        // Reload collection view content to handle content size change
        // When it's finish reloading resize horizontal bar size and position
        // (We can get correct size from content size observer)
        self.updateView()
    }
    
}

private extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
