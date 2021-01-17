//
//  SearchViewController.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/10.
//

import UIKit


class SearchViewController: UIViewController {
    
    var searchResultModel: SearchResultModel!
    
    override func loadView() {
        self.view = SearchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchView = self.view as! SearchView
        
        let searchButton = searchView.searchButton
        
        searchButton?.addTarget(self, action: #selector(showResult), for: .touchUpInside)
        
        
    }
    
    @objc func showResult(){
        
        let searchView = self.view as! SearchView
        let startText = searchView.startTextField.text
        let goalText = searchView.goalTextField.text
        
        let searchResultViewController = SearchResultViewController()
        searchResultViewController.startName = startText!
        searchResultViewController.goalName = goalText!
        
        present(searchResultViewController, animated: true, completion: nil)
        
    }

}
