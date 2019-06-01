//
//  BeaconView.swift
//  Lyv
//
//  Created by Miriam Haart on 5/30/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

@IBDesignable
class BeaconView: UIView {

    let nibName = "BeaconView"
    var contentView:UIView?
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        setupUI()
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
}
    func setupUI() {
        titleView.layer.cornerRadius = 15
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.addBorder(3, color: LyvColors.lightpink)
        imageView.clipsToBounds = true
    }
}
