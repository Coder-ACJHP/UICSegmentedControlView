//
//  ViewController.swift
//  UICSegmentedControlView
//
//  Created by Onur Işık on 13.04.2019.
//  Copyright © 2019 Onur Işık. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController, UICSegmentedControlDelegate {
    
    var centerLabel = UILabel()
    var segmentedControlView: UICSegmentedControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: 0, y: 100, width: 370, height: 50)
        segmentedControlView = UICSegmentedControlView(frame: frame, titleList: ["BEST VIDEOS","FAVORITES","HISTORY"])
        segmentedControlView.cornerRadiuss = frame.height / 2
        segmentedControlView.selectionBarColor = .white
        segmentedControlView.selectionBarTitleColor = .white
        segmentedControlView.selectionBarTitleFont = UIFont.boldSystemFont(ofSize: 13)
        segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlView.delegate = self
        view.addSubview(segmentedControlView)
        
        if #available(iOS 11, *) {
            segmentedControlView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            topLayoutGuide.bottomAnchor.constraint(equalTo: segmentedControlView.topAnchor, constant: 10).isActive = true
        }
        
        centerLabel.textColor = .purple
        centerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        centerLabel.textAlignment = .center
        centerLabel.adjustsFontSizeToFitWidth = true
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerLabel)
        
        
        NSLayoutConstraint.activate([
            segmentedControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControlView.heightAnchor.constraint(equalToConstant: 50),
            
            centerLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 75),
            centerLabel.heightAnchor.constraint(equalToConstant: 50),
            centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }

    func segmentedControlView(_ segmentedControlView: UICSegmentedControlView, didSelectedIndex: Int) {
        centerLabel.text = "Selected index : \(didSelectedIndex)"
    }

}

