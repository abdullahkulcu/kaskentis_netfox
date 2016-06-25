//
//  NFXListController.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

import Foundation

class NFXListController: NFXGenericController {

    var tableData = [NFXHTTPModel]()
    var filteredTableData = [NFXHTTPModel]()

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    
    func updateSearchResultsForSearchControllerWithString(_ searchString: String)
    {
        let predicateURL = Predicate(format: "requestURL contains[cd] '\(searchString)'")
        let predicateMethod = Predicate(format: "requestMethod contains[cd] '\(searchString)'")
        let predicateType = Predicate(format: "responseType contains[cd] '\(searchString)'")
        let predicates = [predicateURL, predicateMethod, predicateType]
        let searchPredicate = CompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let array = (NFXHTTPModelManager.sharedInstance.getModels() as NSArray).filtered(using: searchPredicate)
        self.filteredTableData = array as! [NFXHTTPModel]
    }

    func reloadTableViewData()
    {
    }
    
}
