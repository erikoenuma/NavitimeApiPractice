//
//  SearchView.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/12.
//

import Foundation
import UIKit


class SearchView: UIView{
    
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let view = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
