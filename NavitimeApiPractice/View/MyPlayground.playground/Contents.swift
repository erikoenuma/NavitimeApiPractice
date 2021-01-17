import UIKit

protocol SearchViewDelegate {
    func passAddress(startAddress: String, goalAddress: String)
}

class SearchView: UIView{
    
    var delegate: SearchViewDelegate!
    var start = "横浜"
    var goal = "品川"
    
    func pass(){
        delegate.passAddress(startAddress: start, goalAddress: goal)
    }
    
}

class SearchResultView: SearchViewDelegate{
    
    var startName: String = ""
    var goalName: String = ""
    
    func passAddress(startAddress: String, goalAddress: String) {
        
        self.startName = startAddress
        self.goalName = goalAddress
        print(startName, goalName)
    }
    
    
}

let hoge = SearchView()
let srv = SearchResultView()
hoge.delegate = srv
hoge.pass()

