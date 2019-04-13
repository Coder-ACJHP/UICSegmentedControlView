# UICSegmentedControlView
Fully customizable segmented control view component for IOS written with Swift 4, easy to use it's compatible with all kind of iPhone, iPod and iPads regarding home indicator of X device series in protrait and landscape modes.

## Screen shots: 
<div align=center>
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICSegmentedControlView/blob/master/UICSegmentedControl/Assets.xcassets/ScreenShot-2.dataset/ScreenShot-2.gif">
    <img style="display: inline-block;" src="https://github.com/Coder-ACJHP/UICSegmentedControlView/blob/master/UICSegmentedControl/Assets.xcassets/UICSegmentControlView_ScreenShot.dataset/UICSegmentControlView_ScreenShot.gif" width=350 height=700>
</div>

## Options: 
1 - Single swift file, only you need to copy and past it into your project. <br>
2 - You can customize it also from Storyborad<br>

## How to use? (implementation) 
Usage of UICSegmentedControl is super easy 🎉<br>
 - Download `UICSegmentedControl.swift` and import them to your project.<br>
### For example: 
```
var segmentedControlView: UICSegmentedControlView!

override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 100, width: 370, height: 50)
        segmentedControlView = UICSegmentedControlView(frame: frame, titleList: ["BEST VIDEOS","FAVORITES","HISTORY"])
        segmentedControlView.cornerRadiuss = frame.height / 2
        segmentedControlView.selectionBarColor = .white
        segmentedControlView.selectionBarTitleColor = .white
        segmentedControlView.selectionBarTitleFont = UIFont.boldSystemFont(ofSize: 13)
        segmentedControlView.delegate = self
        view.addSubview(segmentedControlView)
    }
    
    // delegate method implement it from 'UICSegmentedControlDelegate'
    func segmentedControlView(_ segmentedControlView: UICSegmentedControlView, didSelectedIndex: Int) {
        self.selectedIndex = didSelectedIndex
    }
```

## Requirements
Xcode 9 or later <br>
iOS 10.0 or later <br>
Swift 4 or later <br>

#### Licence : 
The MIT License (MIT)
