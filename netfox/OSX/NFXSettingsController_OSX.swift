//
//  NFXSettingsController_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)

import Cocoa
    
class NFXSettingsController_OSX: NFXSettingsController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet var responseTypesTableView: NSTableView!
    @IBOutlet var nfxVersionLabel: NSTextField!
    @IBOutlet var nfxURLButton: NSButton!
    
    private let cellIdentifier = "NFXResponseTypeCell_OSX"
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        self.tableData = HTTPModelShortType.allValues
        self.filters =  NFX.sharedInstance().getCachedFilters()
        
        nfxVersionLabel.stringValue = nfxVersionString
        nfxURLButton.title = nfxURL
        responseTypesTableView.register(NSNib(nibNamed: cellIdentifier, bundle: nil), forIdentifier: cellIdentifier)
        
        reloadTableData()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NFX.sharedInstance().cacheFilters(filters)
    }
    
    // MARK: Actions

    @IBAction func loggingButtonClicked(sender: NSButton) {
        if sender.state == NSOnState {
            NFX.sharedInstance().enable()
        } else {
            NFX.sharedInstance().disable()
        }
    }
    
    @IBAction func clearDataClicked(sender: AnyObject?) {
        NFX.sharedInstance().clearOldData()
        NotificationCenter.default.post(name: "NFXReloadData" as NSNotification.Name, object: nil)
    }
    
    @IBAction func nfxURLButtonClicked(sender: NSButton) {
        NSWorkspace.shared().open(NSURL(string: nfxURL)! as URL)
    }
    
    @IBAction func toggleResponseTypeClicked(sender: NSButton) {
        filters[sender.tag] = !filters[sender.tag]
        NFX.sharedInstance().cacheFilters(filters)
        NotificationCenter.default.post(name: "NFXReloadData" as NSNotification.Name, object: nil)
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.responseTypesTableView.reloadData()
        }
    }
    
    // MARK: Table View Delegate and DataSource
    
    private func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NFXResponseTypeCell_OSX else {
            return nil
        }
        
        let shortType = tableData[row]
        cell.typeLabel.stringValue = shortType.rawValue
        cell.activeCheckbox.state = filters[row] ? NSOnState : NSOffState
        cell.activeCheckbox.tag = row
        cell.activeCheckbox.target = self
        cell.activeCheckbox.action = #selector(NFXSettingsController_OSX.toggleResponseTypeClicked(sender:))
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow: Int) -> Bool {
        return false
    }
    
}

#endif
