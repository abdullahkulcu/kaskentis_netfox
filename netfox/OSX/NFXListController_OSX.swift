//
//  NFXListController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)

import Cocoa

class NFXListController_OSX: NFXListController, NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet var searchField: NSTextField!
    @IBOutlet var tableView: NSTableView!

    var isSearchControllerActive: Bool = false
    var delegate: NFXWindowControllerDelegate?
    
    fileprivate let cellIdentifier = "NFXListCell_OSX"
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        tableView.register(NSNib(nibNamed: cellIdentifier, bundle: nil), forIdentifier: cellIdentifier)
        searchField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NFXListController.reloadTableViewData), name: "NFXReloadData" as NSNotification.Name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NFXListController_OSX.deactivateSearchController), name: "NFXDeactivateSearch" as NSNotification.Name, object: nil)
    }
    
    // MARK: Notifications

    override func reloadTableViewData()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deactivateSearchController()
    {
        self.isSearchControllerActive = false
    }
    
    // MARK: Search
    
    func updateSearchResultsForSearchController()
    {
        self.updateSearchResultsForSearchControllerWithString(searchField.stringValue)
        reloadTableViewData()
    }

    func controlTextDidChange(obj: NSNotification) {
        guard let searchField = obj.object as? NSSearchField else {
            return
        }
        
        isSearchControllerActive = searchField.stringValue.characters.count > 0
        updateSearchResultsForSearchController()
    }
    
    // MARK: UITableViewDataSource
    
    private func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if (self.isSearchControllerActive) {
            return self.filteredTableData.count
        } else {
            return NFXHTTPModelManager.sharedInstance.getModels().count
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NFXListCell_OSX else {
            return nil
        }
        
        if (self.isSearchControllerActive) {
            if self.filteredTableData.count > 0 {
                let obj = self.filteredTableData[row]
                cell.configForObject(obj: obj)
            }
        } else {
            if NFXHTTPModelManager.sharedInstance.getModels().count > 0 {
                let obj = NFXHTTPModelManager.sharedInstance.getModels()[row]
                cell.configForObject(obj: obj)
            }
        }
        
        return cell
    }
    
    // MARK: NSTableViewDelegate

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 58
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        var model: NFXHTTPModel
        if (self.isSearchControllerActive) {
            model = self.filteredTableData[self.tableView.selectedRow]
        } else {
            model = NFXHTTPModelManager.sharedInstance.getModels()[self.tableView.selectedRow]
        }
        self.delegate?.httpModelSelectedDidChange(model: model)
    }
    
}

#endif
